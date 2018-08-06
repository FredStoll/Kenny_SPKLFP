%- Resample signal
 
 clear
 list = dir('*lfp spk*.mat')


for mm = 1 : length(list)
    
    load([list(mm).name])
        %- subsampling at 256Hz
    cfg = [];
    cfg.resamplefs = 256;
    cfg.detrend = 'no';
    [data_lfp] = ft_resampledata(cfg, data_lfp);
    
    save([list(mm).name(1:end-4) ' lfp subsampled.mat'],'spike','data_lfp','evt')
   
end
