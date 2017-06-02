%---------------------------------------------------
%Needed variables: 1. Path to TwoEars-master folder
%                  2. Path to DSD100 dataset
%                  3. Output path
%---------------------------------------------------

%Import Two!Ears Auditory Model
addpath('your_TwoEars-master_path')
startTwoEars

%Input and output paths
DSD100_path = ['your_DSD100_path']
binaural_DSD100_path = ['your_output_path']

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

    file_ang = fopen(['BDSD100_angles_' char(dev_test(g)) '.txt'],'w');

    for idx = 1:50

        %Input and output path for each song
        inputpath = [char(dataset_path) filesep char(folder_list(idx)) filesep]
        outputpath_mix = [char(binaural_DSD100_path) filesep 'Mixtures' filesep char(dev_test(g)) filesep char(folder_list(idx)) filesep]
        outputpath_sources = [char(binaural_DSD100_path) filesep 'Sources' filesep char(dev_test(g)) filesep char(folder_list(idx)) filesep]

        %Random angles in radians (counter-clockwise)
        angles = rand(4,1)*2*pi;
        sin(angles);
        cos(angles);

        fprintf(file_ang,'%6.4f %6.4f %6.4f %6.4f\n',angles);

        %Binaural simulator for four sources
        sim = simulator.SimulatorConvexRoom();
        set(sim, ...
            'HRIRDataset', simulator.DirectionalIR( ...
                'impulse_responses\qu_kemar_anechoic\QU_KEMAR_anechoic_1m.sofa'), ...
            'Sources', {simulator.source.Point(), simulator.source.Point(), simulator.source.Point(), simulator.source.Point()}, ...
            'Sinks',   simulator.AudioSink(2) ...
            );
        set(sim.Sources{1}, ...
            'Name', 'drums', ...
            'Position', [sin(angles(1)); -cos(angles(1)); 0], ...
            'AudioBuffer', simulator.buffer.FIFO(1) ...
            );
        set(sim.Sources{1}.AudioBuffer, ...
            'File', [inputpath 'drums.wav'] ...
            );
        set(sim.Sources{2}, ...
            'Name', 'vocals', ...
            'Position', [sin(angles(2)); -cos(angles(2)); 0], ...
            'AudioBuffer', simulator.buffer.FIFO(1) ...
            );
        set(sim.Sources{2}.AudioBuffer, ...
            'File', [inputpath 'vocals.wav'] ...
            );
        set(sim.Sources{3}, ...
            'Name', 'bass', ...
            'Position', [sin(angles(3)); -cos(angles(3)); 0], ...
            'AudioBuffer', simulator.buffer.FIFO(1) ...
            );
        set(sim.Sources{3}.AudioBuffer, ...
            'File', [inputpath 'bass.wav'] ...
            );
        set(sim.Sources{4}, ...
            'Name', 'other', ...
            'Position', [sin(angles(4)); -cos(angles(4)); 0], ...
            'AudioBuffer', simulator.buffer.FIFO(1) ...
            );
        set(sim.Sources{4}.AudioBuffer, ...
            'File', [inputpath 'other.wav'] ...
            );
        set(sim.Sinks, ...
            'Name', 'Head', ...
            'UnitX', [1; 0; 0], ...
            'Position', [0; 0; 0] ...
            );

        %% initialization
        % note that all the parameters including objects' positions have to be
        % defined BEFORE initialization in order to init properly
        sim.set('Init',true);

        %%
        while ~sim.isFinished()
            sim.set('Refresh',true);  % refresh all objects
            sim.set('Process',true);
        end

        %Checking if the output directory exists. If not, creates it
        if ~exist(outputpath_mix, 'dir')
            mkdir(outputpath_mix)
            disp(outputpath_mix)
            disp('THE OUTPUT FOLDER DID NOT EXIST, CREATING IT...')
        end


        %Saves the file in the output directory
        data = sim.Sinks.getData();
        sim.Sinks.saveFile([outputpath_mix 'binaural.wav'],sim.SampleRate);
        sim.plot();
        sim.set('ShutDown',true);

        sources = ["drums.wav", "vocals.wav", "bass.wav", "other.wav"]

        for k = 1:4

            %Binaural simulator for each source
            sim1 = simulator.SimulatorConvexRoom();
            set(sim1, ...
                'HRIRDataset', simulator.DirectionalIR( ...
                    'impulse_responses\qu_kemar_anechoic\QU_KEMAR_anechoic_1m.sofa'), ...
                'Sources', {simulator.source.Point()}, ...
                'Sinks',   simulator.AudioSink(2) ...
                );
            set(sim1.Sources{1}, ...
                'Name', 'single', ...
                'Position', [sin(angles(k)); -cos(angles(k)); 0], ...
                'AudioBuffer', simulator.buffer.FIFO(1) ...
                );
            set(sim1.Sources{1}.AudioBuffer, ...
                'File', [inputpath char(sources(k))] ...
                );
            set(sim1.Sinks, ...
                'Name', 'Head', ...
                'UnitX', [1; 0; 0], ...
                'Position', [0; 0; 0] ...
                );

            %% initialization
            % note that all the parameters including objects' positions have to be
            % defined BEFORE initialization in order to init properly
            sim1.set('Init',true);

            %%
            while ~sim1.isFinished()
                sim1.set('Refresh',true);  % refresh all objects
                sim1.set('Process',true);
            end

            %Checking if the output directory exists. If not, creates it
            if ~exist(outputpath_sources, 'dir')
                mkdir(outputpath_sources)
                disp(outputpath_sources)
                disp('THE OUTPUT FOLDER DID NOT EXIST, CREATING IT...')
            end

            %Saves the file in the output directory
            data1 = sim1.Sinks.getData();
            sim1.Sinks.saveFile([outputpath_sources char(sources(k))],sim1.SampleRate);
            sim1.plot();
            sim1.set('ShutDown',true);

        end

    end

    fclose(file_ang);

end
