% SIRiterator
%
% Gabriella Chan 28/06/23
% gabriella.chan@monash.edu
% Monash University
%
%
% This module serves as an intermediate layer to call SIR simulator
% and SIR atrophy.
%
% We iterate through all gene pairs and their gene expression and call SIR
% simulator to store an array of normal protein expression over regions 
% over time, and misfolded protein expression over regions over time.
%
% From this we derive theortical atrophy per region for each gene and
% correlate with empirical atrophy per region per gene.

function [gene_corrs, sim_atrophy] = SIRiterator(N_regions, v, dt, T_total, clear_genes, risk_genes, ...
    sconnLen, sconnDen, ROIsize, seed, syn_control, init_number, prob_stay, ...
    trans_rate, emp_atrophy)

gene_corrs = table('Size', [width(risk_genes)*width(clear_genes), 4], ...
    'VariableTypes', {'string', 'string', 'double', 'double'}, ...
    'VariableNames', {'risk gene', 'clearance gene', 'correlation', 't'});

for risk_gene = 1:width(risk_genes)
    %tic
    gene_name = risk_genes.Properties.VariableNames{risk_gene};
    disp(gene_name)
    for clear_gene = 1:width(clear_genes)
        %%%%% simulation ------ >>>
        clear_name = clear_genes.Properties.VariableNames{clear_gene};
        [Rnor_all, Rmis_all] = SIRsimulator(N_regions, v, dt, T_total, clear_genes(:,clear_gene), ...
            risk_genes(:,risk_gene), sconnLen, sconnDen, ROIsize, seed, syn_control, ...
            init_number, prob_stay, trans_rate);
        [sim_atrophy] = SIRatrophy(Rnor_all, Rmis_all, sconnDen, N_regions, dt);
        [corr, tstep] = SIRcorr(sim_atrophy, emp_atrophy);
        gene_corrs(risk_gene,:) = {gene_name, clear_name, corr, tstep};
    end
    %toc
end

gene_corrs = sortrows(gene_corrs, 2);

end
