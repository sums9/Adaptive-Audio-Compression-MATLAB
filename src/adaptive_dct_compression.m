%% Team 10: Hardware-Driven Signal Processing
if ~exist('a', 'var') || ~isa(a, 'arduino')
    a = arduino('COM3', 'Uno'); 
end

% --- NEW FEATURE: HARDWARE SENSING ---
fprintf('Consulting Hardware for Compression Parameters...\n');
% Read the floating voltage on Analog Pin 0 (0 to 5V)
sensorValue = readVoltage(a, 'A0'); 

% Convert 0-5V into a Keep Ratio between 0.05 (high compression) and 0.3 (low compression)
keepRatio = 0.05 + (sensorValue / 5) * 0.25; 

fprintf('Hardware Selected Keep Ratio: %.4f (Based on Ambient Voltage: %.2fV)\n', keepRatio, sensorValue);

% --- Load Audio ---
[audio, fs] = audioread('Sound_1.wav'); 
audio = audio(:,1); 
blockSize = 256; 

tic; 
writeDigitalPin(a, 'D13', 1); % LED ON

% --- Block-wise DCT Processing ---
paddedAudio = [audio; zeros(blockSize - mod(length(audio), blockSize), 1)];
reconstructed = zeros(size(paddedAudio));

for i = 1:blockSize:length(paddedAudio)-blockSize
    block = paddedAudio(i:i+blockSize-1);
    d = dct(block); 
    
    numToKeep = round(blockSize * keepRatio);
    d(numToKeep+1:end) = 0; 
    
    reconstructed(i:i+blockSize-1) = idct(d);
end

writeDigitalPin(a, 'D13', 0); % LED OFF
elapsedTime = toc;

%% Final Report
mseVal = mean((paddedAudio - reconstructed).^2); 
snrVal = 10 * log10(sum(paddedAudio.^2) / sum((paddedAudio - reconstructed).^2));

fprintf('\n--- TEAM 10 FINAL REPORT ---\n');
fprintf('Source: Hardware-Inferred Parameters\n');
fprintf('Processing Time: %.4f seconds\n', elapsedTime);
fprintf('MSE: %.6f | SNR: %.2f dB\n', mseVal, snrVal);
fprintf('----------------------------\n');

sound(reconstructed, fs);