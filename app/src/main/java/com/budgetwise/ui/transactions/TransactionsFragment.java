package com.budgetwise.ui.transactions;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;
import androidx.lifecycle.ViewModelProvider;
import androidx.recyclerview.widget.LinearLayoutManager;
import com.budgetwise.BudgetWiseApplication;
import com.budgetwise.databinding.FragmentTransactionsBinding;
import com.budgetwise.ui.adapters.TransactionAdapter;
import com.google.android.material.floatingactionbutton.FloatingActionButton;

public class TransactionsFragment extends Fragment {
    private FragmentTransactionsBinding binding;
    private TransactionsViewModel viewModel;
    private TransactionAdapter adapter;

    public View onCreateView(@NonNull LayoutInflater inflater,
                             ViewGroup container, Bundle savedInstanceState) {
        binding = FragmentTransactionsBinding.inflate(inflater, container, false);
        
        setupViewModel();
        setupRecyclerView();
        setupFab();
        observeData();
        
        return binding.getRoot();
    }

    private void setupViewModel() {
        TransactionsViewModelFactory factory = new TransactionsViewModelFactory(
            BudgetWiseApplication.getInstance().getBudgetRepository()
        );
        viewModel = new ViewModelProvider(this, factory).get(TransactionsViewModel.class);
    }

    private void setupRecyclerView() {
        adapter = new TransactionAdapter(new TransactionAdapter.OnTransactionClickListener() {
            @Override
            public void onTransactionClick(com.budgetwise.data.models.Transaction transaction) {
                // Handle transaction click - open edit dialog
                AddTransactionDialogFragment dialog = AddTransactionDialogFragment.newInstance(transaction);
                dialog.show(getParentFragmentManager(), "edit_transaction");
            }
            
            @Override
            public void onTransactionEdit(com.budgetwise.data.models.Transaction transaction) {
                // Handle edit button click - open edit dialog
                AddTransactionDialogFragment dialog = AddTransactionDialogFragment.newInstance(transaction);
                dialog.show(getParentFragmentManager(), "edit_transaction");
            }
            
            @Override
            public void onTransactionDelete(com.budgetwise.data.models.Transaction transaction) {
                // Handle delete button click - show confirmation dialog
                showDeleteConfirmationDialog(transaction);
            }
        });
        
        binding.recyclerViewTransactions.setLayoutManager(new LinearLayoutManager(getContext()));
        binding.recyclerViewTransactions.setAdapter(adapter);
    }

    private void setupFab() {
        binding.fabAddTransaction.setOnClickListener(v -> {
            AddTransactionDialogFragment dialog = AddTransactionDialogFragment.newInstance(null);
            dialog.show(getParentFragmentManager(), "add_transaction");
        });
    }

    private void observeData() {
        viewModel.getTransactions().observe(getViewLifecycleOwner(), transactions -> {
            adapter.submitList(transactions);
            updateEmptyState(transactions.isEmpty());
        });

        viewModel.getTotalIncome().observe(getViewLifecycleOwner(), income -> {
            binding.textTotalIncome.setText(String.format("$%.2f", income));
        });

        viewModel.getTotalExpenses().observe(getViewLifecycleOwner(), expenses -> {
            binding.textTotalExpenses.setText(String.format("$%.2f", expenses));
        });
    }

    private void updateEmptyState(boolean isEmpty) {
        if (isEmpty) {
            binding.layoutEmptyState.setVisibility(View.VISIBLE);
            binding.recyclerViewTransactions.setVisibility(View.GONE);
        } else {
            binding.layoutEmptyState.setVisibility(View.GONE);
            binding.recyclerViewTransactions.setVisibility(View.VISIBLE);
        }
    }
    
    private void showDeleteConfirmationDialog(com.budgetwise.data.models.Transaction transaction) {
        new androidx.appcompat.app.AlertDialog.Builder(requireContext())
            .setTitle("Delete Transaction")
            .setMessage("Are you sure you want to delete this transaction?\n\n" + 
                       transaction.getDescription() + "\n" +
                       String.format("$%.2f", transaction.getAmount()))
            .setPositiveButton("Delete", (dialog, which) -> {
                BudgetWiseApplication.getInstance().getBudgetRepository().deleteTransaction(transaction.getId());
                com.google.android.material.snackbar.Snackbar.make(binding.getRoot(), 
                    "Transaction deleted", com.google.android.material.snackbar.Snackbar.LENGTH_SHORT)
                    .setAction("Undo", v -> {
                        // Re-add the transaction (undo functionality)
                        BudgetWiseApplication.getInstance().getBudgetRepository().addTransaction(transaction);
                    })
                    .show();
            })
            .setNegativeButton("Cancel", null)
            .setIcon(android.R.drawable.ic_dialog_alert)
            .show();
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();
        binding = null;
    }
}
