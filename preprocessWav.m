%% Dividing each audio spectrogram in sections. For each spectrogram:
% - click attenuation
% - band-pass filter 5kHz-20kHz
% - power threshold
% - creation of a struct for each section of the spectrogram, containing
% fields --> filename
%        --> spectro: matrix containing spectrograms values
%        --> range: time interval in seconds
%        --> label: 0/1 (non-whistle/whistle)

folder = 'E:\whistle_identification\recordings-dataset1';
files = dir([folder,filesep,'*.wav']);
for f = 1:length(files)
    fileName = [folder, '/', files(f).name];
    name = files(f).name;
    [x,fs] = audioread(fileName);
    x1 = downsample(x,2);
    load('Whistles_1.mat');


    tresh=5; %threshold for click removal
    p=0; %power for click removal
    window_size = 512;
    overlap = window_size/2;

    %%%%
    specSamples = 224;
    oneSec = fs/overlap;
    secs = (specSamples*fs)/oneSec;
    time = secs/fs;
    %%%%

    numstps = length(x1)/(secs);
    start = 1;
    spectrograms = [];
    % For each interval: signal filtering, creates the spectrograms and save it in format '.png'
    for i = 1:numstps
        
        xi= x1(start:start+secs);
        xi=xi(:);
        range = [(i-1)*time, ((i-1)*time)+time];

        % Remove clicks from the signal
        sd=std(xi);
        mu=mean(xi);
        wi=1./(1+((xi-mu)/(tresh*sd)).^p);% Weighting function
        xn = xi.*wi;  % weighted signal (declicked)

        % Band-pass filter 5kHz-20kHz
        fpass = [5000, 20000];
        filtered = bandpass(xn, fpass, fs);
        
        [spectro, frequencies, times] = spectrogram(filtered, window_size, overlap,[],fs);
        db = 20*log10(abs(spectro));

        % Power threshold
        spectro_mod = spectro;
        spectro_mod(db<=-35) = 0;

        % Amplify the signal power (if necessary)
        db1 = 20*log10(abs(spectro_mod));
        db_mod = db1*(1/10);
        spectro_mod_int = 10.^(db_mod / 20);

        % Create and save the struct
        myStruct.fileName = fileName;
        myStruct.range = range;
        myStruct.spectro = spectro_mod_int(1:specSamples,:);
        %imwrite(spectro_mod, ['/MATLAB Drive/whistle_classification/prova/spectrograms/spectro' num2str(i) '.png']);
        


        for j = 1:length(whistles)
            if strcmp(whistles{j,1}.file, name)
                cond1 = whistles{j,1}.Range(1)>= range(1) && whistles{j,1}.Range(2)<= range(2);
                cond2 = whistles{j,1}.Range(1)>= range(1) && whistles{j,1}.Range(1)<= range(2);
                cond3 = whistles{j,1}.Range(2)>= range(1) && whistles{j,1}.Range(2)<= range(2);
                if cond1 || cond2 || cond3
                    myStruct.label = 1;
                    break;
                else
                    myStruct.label = 0;
                end

            end
        end

        spectrograms = [spectrograms; myStruct];
        start=start+secs+1;

    end

    save(['E:\whistle_identification\DOLPHI\labels48kHz/spectrograms' name(1:end-4) '.mat'], 'spectrograms');
    
end

%% Create file.png contaning spectrograms images
path = 'E:\whistle_identification\DOLPHI\labels48kHz';
files = dir([path,filesep,'*.mat']);
h = 1;


for i = 1:length(files)
    load([path,'/',files(i).name]);
    for j = 1:length(spectrograms)
        
        
        spectro = spectrograms(j).spectro;
        imwrite(spectro, ['E:\whistle_identification\DOLPHI\images48kHz/Spctr' num2str(h) '.png']);
        h = h + 1;
    end

end

%% Create labels list
path = 'E:\whistle_identification\DOLPHI\labels48kHz';
files = dir([path,filesep,'*.mat']);
labels = [];

for i = 1:length(files)
    load([path '/' files(i).name]);
    for j = 1:length(spectrograms)

            label = spectrograms(j).label;
            labels = [labels; label];


    end

end

save('labels48kHz.mat', 'labels');

