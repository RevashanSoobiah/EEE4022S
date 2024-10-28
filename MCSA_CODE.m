% Step 1: Load the data from CSV files
opts = detectImportOptions("C:\Users\Revashan\OneDrive - University of Cape Town\Desktop\EEE4022S\MCSA\10%\Vary Load\100%Load_10%Faulted.csv");  
opts.DataLines = [24 Inf];
opts2 = detectImportOptions("C:\Users\Revashan\OneDrive - University of Cape Town\Desktop\EEE4022S\MCSA\10%\Vary Load\NoLoad_10%Faulted.csv");
opts2.DataLines = [24 Inf];


data = readtable("C:\Users\Revashan\OneDrive - University of Cape Town\Desktop\EEE4022S\MCSA\10%\Vary Load\100%Load_10%Faulted.csv", opts);
data2 = readtable("C:\Users\Revashan\OneDrive - University of Cape Town\Desktop\EEE4022S\MCSA\10%\Vary Load\NoLoad_10%Faulted.csv", opts2);
%data3 = readtable("C:\Users\Revashan\OneDrive - University of Cape Town\Desktop\EEE4022S\MCSA\10%\Vary Load\50%Load_10%Faulted.csv");
 


% Step 2: Extract x (time) and y (current) data
x = data{:, 1};  
y = data{:, 5};  
x1 = data2{:,1};
y_Faulted_10 = data2{:,5};

%x2 = data3{24:end ,1};
%y_Faulted_5 = data3{25:end,5};





% Sampling frequency and time step
fs = 50000;  %
T = 1/fs;


%Cut off for Lowpass frequency
cutoffFreq = 10000;   
fs = 20000;           


% Apply the lowpass filter to the 'y' column
%yFiltered = lowpass(y, cutoffFreq, fs);
%yFiltered2 = lowpass(y_Faulted_10, cutoffFreq, fs);
%yFiltered3 = lowpass(y3, cut, fs);
%yFiltered4 = lowpass(y4, cut, fs);



% Apply Hann window to both healthy and faulted data
HannLength = length(yFiltered);  %
NHann = (0:HannLength-1)';
Window = 0.5*(1 - cos(2*pi*NHann/HannLength));  


% Hann window
windowedData_Healthy = yFiltered.* Window; 
windowedData_Faulted = yFiltered2 .* Window; 

% Step 3: FFT parameters
NFFT = 2^nextpow2(HannLength);  % Zero-padding
f1 = (fs/NFFT)*(0:NFFT/2-1);  

% Getting the fft
Y = fft(windowedData_Healthy, NFFT);  % Healthy motor FFT
Y1 = Y(1:NFFT/2);           % Take first half of FFT (positive frequencies)

Y_Faulted = fft(windowedData_Faulted, NFFT);  % Faulted motor FFT
Y_Faulted = Y_Faulted(1:NFFT/2);

%Y_Faulted_5 = fft(y_Faulted_windowed_5, NFFT);  % Faulted motor FFT
%Y_Faulted_5 = Y_Faulted_5(1:NFFT/2);


% Power Spectral Density (PSD)
PSD = Y1 .* conj(Y1) / NFFT;  % Healthy motor PSD

PSD_Faulted = Y_Faulted .* conj(Y_Faulted) / NFFT; %Faulted 

%PSD_Faulted_5 = Y_Faulted_5.* conj(Y_Faulted_5)/NFFT;


% Step 4: Plot results
figure;
plot(f1(100:10000), 10*log10(PSD(100:10000))-52.9492);  % Healthy motor PSD
hold on;
%plot(f1(100:10000), 10*log10(PSD_Faulted_5(100:10000))-52.1892);
plot(f1(100:10000), 10*log10(PSD_Faulted(100:10000))-49.7157);  % Faulted motor PSD
  % Healthy motor PSD
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
title('Magnitude (dB) vs Frequency for Healthy and Faulted Motor');
legend('100% Load Motor', '50% Load Motor','No Load Motor');
grid on;











