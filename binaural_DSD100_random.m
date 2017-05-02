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

s = dir(DSD100_path);

%It takes the names of each song folder
folder_list = {s.name};
% !!! Make sure it takes only the correct folders (avoid '.', '..' and other
% !!! hidden folders) by properly modifying the start number of the array
folder_list = string(folder_list(3:end));

file_ang = fopen('BDSD100_angles.txt','w');

%For loop for all DSD100 dataset
%for idx = 1:numel(folder_list)
for idx = 1:50
    
    %Input and output path for each song
    inputpath = [char(DSD100_path) char(folder_list(idx)) '/']
    outputpath = [char(binaural_DSD100_path) '/Sources/Test/' char(folder_list(idx)) '/']
    
    %Random angles in radians (counter-clockwise)
    angles = rand(4,1)*2*pi;
    sin(angles);
    cos(angles);
   
    fprintf(file_ang,'%6.4f %6.4f %6.4f %6.4f\n',angles);
    
    %Binaural simulator for four sources
    sim = simulator.SimulatorConvexRoom();
    set(sim, ...
        'HRIRDataset', simulator.DirectionalIR( ...
            'impulse_responses/qu_kemar_anechoic/QU_KEMAR_anechoic_1m.sofa'), ...
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
    if ~exist(outputpath, 'dir')
        mkdir(outputpath)
        disp(outputpath)
        disp('THE OUTPUT FOLDER DID NOT EXIST, CREATING IT...')
    end
    
    
    %Saves the file in the output directory
    data = sim.Sinks.getData();
    sim.Sinks.saveFile([outputpath 'binaural.wav'],sim.SampleRate);
    sim.plot();
    sim.set('ShutDown',true);
    
end

fclose(file_ang);