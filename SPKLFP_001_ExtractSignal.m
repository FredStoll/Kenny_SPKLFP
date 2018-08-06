
%- event in mat file? check with the events in the lfp file?
%- could do TF and extract instantaneous phase and amplitude? then look for bursts depending on BL,
%and look at spike at a given phase?
% PPC? hard

clear

cd('H:\KennyLab_DATA\SPK_LFP_Coherence\ALL\')

list = dir('*WB*.plx');

 for i = 1 : length(list)

    clearvars -except mainsheet i ALL list
    disp(i)
    
    %- get data from Plexon
    StartingFileName = list(i).name;
    
    readall;
    
    %- keep only what I need
    clearvars -except allad tsevs evnames evcounts adfreq OpenedFileName list i ALL
    
    %- find the signal (only one channel normally)
    for m = 1 : length(allad)
        if ~isempty(allad{m})
            keepit = m;
        end
    end
    
    data = allad{keepit};
    data = single(data);
    clear allad
        
    %- FT format
    data_lfp.label{1} = '1';
    data_lfp.fsample = adfreq;
    data_lfp.time{1} = single([1:length(data)] * (1/adfreq));
    data_lfp.trial{1} = data';
    data_lfp.sampleinfo(1,:)=[1 length(data)];
    clear data

    evt = tsevs;
    
    %- look for the spike data
    temp = dir([OpenedFileName(1:32) '*only.plx']);
    
    StartingFileName = temp.name;
    
    readall;

    %- find the spikes timestamps (only one channel normally)
    keepit=[];p=0;
    clear spike
    for m = 1 : length(allts(:,1))
        for n = 1 : length(allts(1,:))
            if ~isempty(allts{m,n})
                keepit = [keepit ; m n];
                p = p + 1;
                spike(p).timestamp{1} = allts{m,n}';
                spike(p).label{1} = ['spk' num2str(m) '_' num2str(n)];
                spike(p).waveform{1}(1,:,:) = NaN;
                spike(p).dimord = '{chan}_lead_time_spike';

            end
        end
    end
    
    clear allts allad
    save([OpenedFileName(1:32) ' lfp spk.mat'],'spike','data_lfp','evt')

 end
 