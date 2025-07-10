package com.budgetwise.ui.dashboard;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;
import androidx.lifecycle.ViewModelProvider;
import androidx.recyclerview.widget.LinearLayoutManager;
import com.budgetwise.BudgetWiseApplication;
import com.budgetwise.databinding.FragmentDashboardBinding;
import com.budgetwise.ui.adapters.BudgetAdapter;
import com.budgetwise.ui.adapters.RecentTransactionAdapter;

public class DashboardFragment extends Fragment {
    private FragmentDashboardBinding binding;
    private DashboardViewModel viewModel;
    private BudgetAdapter budgetAdapter;
    private RecentTransactionAdapter transactionAdapter;

    public View onCreateView(@NonNull LayoutInflater inflater,
                             ViewGroup container, Bundle savedInstanceState) {
        binding = FragmentDashboardBinding.inflate(inflater, container, false);
        
        setupViewModel();
        setupRecyclerViews();
        observeData();
        
        return binding.getRoot();
    }

    private void setupViewModel() {
        DashboardViewModelFactory factory = new DashboardViewModelFactory(
            BudgetWiseApplication.getInstance().getBudgetRepository(),
            BudgetWiseApplication.getInstance().getIntelligenceService()
        );
        viewModel = new ViewModelProvider(this, factory).get(DashboardViewModel.class);
    }

    private void setupRecyclerViews() {
        // Setup budgets RecyclerView
        budgetAdapter = new BudgetAdapter();
        binding.recyclerViewBudgets.setLayoutManager(new LinearLayoutManager(getContext()));
        binding.recyclerViewBudgets.setAdapter(budgetAdapter);

        // Setup recent transactions RecyclerView
        transactionAdapter = new RecentTransactionAdapter();
        binding.recyclerViewRecentTransactions.setLayoutManager(new LinearLayoutManager(getContext()));
        binding.recyclerViewRecentTransactions.setAdapter(transactionAdapter);
    }

    private void observeData() {
        viewModel.getBudgets().observe(getViewLifecycleOwner(), budgets -> {
            budgetAdapter.submitList(budgets);
            updateBudgetSummary(budgets);
        });

        viewModel.getRecentTransactions().observe(getViewLifecycleOwner(), transactions -> {
            transactionAdapter.submitList(transactions);
        });

        viewModel.getTotalBalance().observe(getViewLifecycleOwner(), balance -> {
            binding.textTotalBalance.setText(String.format("$%.2f", balance));
        });

        viewModel.getMonthlySpending().observe(getViewLifecycleOwner(), spending -> {
            binding.textMonthlySpending.setText(String.format("$%.2f", spending));
        });

        viewModel.getInsights().observe(getViewLifecycleOwner(), insights -> {
            updateInsightsSection(insights);
        });
    }

    private void updateBudgetSummary(java.util.List<com.budgetwise.data.models.Budget> budgets) {
        if (budgets.isEmpty()) {
            binding.textBudgetSummary.setText("No budgets set");
            return;
        }

        int totalBudgets = budgets.size();
        long overBudget = budgets.stream().mapToLong(b -> b.isOverBudget() ? 1 : 0).sum();
        
        binding.textBudgetSummary.setText(String.format("%d budgets, %d over limit", totalBudgets, overBudget));
    }

    private void updateInsightsSection(java.util.List<String> insights) {
        if (insights.isEmpty()) {
            binding.textInsights.setText("No insights available");
            binding.textInsights.setVisibility(View.GONE);
        } else {
            binding.textInsights.setText(insights.get(0)); // Show first insight
            binding.textInsights.setVisibility(View.VISIBLE);
        }
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();
        binding = null;
    }
}
