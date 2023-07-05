% SIRatrophy
%
% Gabriella Chan 28/06/23
% gabriella.chan@monash.edu
% Monash University
%
% 
%
%

function [sim_atrophy] = SIRatrophy(Rnor_all, Rmis_all, sconnDen, N_regions, dt)

ratio = Rmis_all ./(Rnor_all + Rmis_all) ;
ratio(Rmis_all<1) = 0; % remove possible NaNs...

% atrophy growth
k1 = 0.5;
k2 = 1 - k1;
% input weigths of deafferentation (scaled by structrual connectivity)
weights = sconnDen ./ repmat(sum(sconnDen, 2), 1, N_regions);

% neuronal loss caused by lack of input from neighbouring regions
ratio_cum = weights * (1-exp(-ratio * dt));
% one time step back
ratio_cum = [zeros(N_regions, 1), ratio_cum(:, 1:end-1)];
ratio_cum = k2 * ratio_cum + k1 * (1-exp(-ratio * dt));

% add all the increments across t
sim_atrophy = cumsum(ratio_cum, 2);

end