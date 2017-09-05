%Input and output paths
DSD100_path = ['DSD100']
monaural_DSD100_path = ['MDSD100']

dev_test = ["Dev","Test"]

%It takes the names of each song folder
%folder_list = {s.name};
%Make sure it takes only the correct folders (avoid '.', '..' and other
%hidden folders) by properly modifying the start number of the array
%folder_list = string(folder_list(3:end));

%For loop for all DSD100 dataset
%for idx = 1:numel(folder_list)
for g = 1:2
    
    dataset_path = [char(DSD100_path) filesep 'Sources' filesep char(dev_test(g))]
    
    s = dir(dataset_path);
    s = s([s.isdir]);
    s(strncmp({s.name},'.',1)) = []

    folder_list = string({s.name})
    
    for idx = 1:50

        %Input and output path for each song
        inputpath_mix = [char(DSD100_path) filesep 'Mixtures' filesep char(dev_test(g)) filesep char(folder_list(idx)) filesep]
        inputpath_sources = [char(DSD100_path) filesep 'Sources' filesep char(dev_test(g)) filesep char(folder_list(idx)) filesep]
        outputpath_mix = [char(monaural_DSD100_path) filesep 'Mixtures' filesep char(dev_test(g)) filesep char(folder_list(idx)) filesep]
        outputpath_sources = [char(monaural_DSD100_path) filesep 'Sources' filesep char(dev_test(g)) filesep char(folder_list(idx)) filesep]

        [mix,Fs] = audioread([inputpath_mix 'mixture.wav']);
        
        monaural = (mix(:,1)+mix(:,2))/2;
        monaural_2ch = cat(2,monaural,monaural);
        
        disp(size(monaural_2ch))
        
        %Checking if the output directory exists. If not, creates it
        if ~exist(outputpath_mix, 'dir')
            mkdir(outputpath_mix)
            disp(outputpath_mix)
            disp('THE OUTPUT FOLDER DID NOT EXIST, CREATING IT...')
        end

        filename = [outputpath_mix 'monaural.wav']
        audiowrite(filename,monaural_2ch,Fs);
        
        sources = ["drums.wav", "vocals.wav", "bass.wav", "other.wav"]

        for k = 1:4

            [source,Fs] = audioread([inputpath_sources char(sources(k))]);
        
            monaural = (source(:,1)+source(:,2))/2;
            monaural_2ch = cat(2,monaural,monaural);
        
            disp(size(monaural_2ch))

            %Checking if the output directory exists. If not, creates it
            if ~exist(outputpath_sources, 'dir')
                mkdir(outputpath_sources)
                disp(outputpath_sources)
                disp('THE OUTPUT FOLDER DID NOT EXIST, CREATING IT...')
            end
            
            filename = [outputpath_sources char(sources(k))]
            audiowrite(filename,monaural_2ch,Fs);
            
        end

    end
    
end