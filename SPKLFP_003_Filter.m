%- should be using Matlab 2014b, problem otherwise

clear
 list = dir('*lfp subsampled.mat')
 load('Exp2_Events.mat')
 thresh=5*ones(size(list));thresh([9 13 26])=1;thresh([32 33])=2;

for mm = 1 : length(list)
    
    load([list(mm).name])        
    
    %- matche loaded file with event / factor tables
    %- Align around Rewards (+ correct the evt matrix..)
    idxEvts(mm) = find(Factors.rat==Exp_Order(mm,1) & Factors.treatment==Exp_Order(mm,2) & Factors.dose==Exp_Order(mm,3) );
    evt = Events(idxEvts(mm),:); % can put 2 to have the nicotine injection

    %- filtering
    cfg=[];
    cfg.bpfilter = 'yes';
    cfg.bpfreq = [2 30];
    data_filtered = ft_preprocessing(cfg,data_lfp);
    
    save([list(mm).name(1:end-26) ' lfp filtered TF.mat'],'spike','data_filtered','evt')
    
end

