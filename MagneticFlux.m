close all;
clear;

% Read data from CSV files
data = readtable("C:\Users\Revashan\Downloads\90v1.csv"); %0 & 180 --> 5 and 3
data2 = readtable("C:\Users\Revashan\OneDrive - University of Cape Town\Desktop\EEE4022S\FlatCoil\MotorR\PositionC\10%\scope_49.csv"); % 90 & 270 --> 2 and 4
%data3 = readtable("C:\Users\Revashan\OneDrive - University of Cape Town\Desktop\EEE4022S\FlatCoil\MotorR\PositionC\10%\scope_50.csv");
%data4 = readtable();

% Extract x and y data for both datasets
x1 = data{3:end, 1}; % x data from first file
y1 = data{3:end, 2}; % y data from first file
x2 = data2{3:end, 1}; % x data from second file
y2 = data2{3:end, 2}; % y data from second file

x3 = data3{3:end, 1}; % x data from third file
y3 = data3{3:end, 2}; % y data from third file
x4 = data{3:end, 1}; % x data from fourth file
y4 = data{3:end, 2}; % y data from fourth file

t = x(end) - x(1);  % Total time duration
Length_t = length(x);  % Number of samples
Fs = Length_t / t;  % Sampling frequency
Ts = 1 / Fs;  % Sampling time




%Cut off for Lowpass frequency
cutoffFreq = 10000;   
fs = 20000;           


% Apply the lowpass filter to the 'y' column
yFiltered = lowpass(y, cutoffFreq, fs);
yFiltered2 = lowpass(y2, cutoffFreq, fs);
%yFiltered3 = lowpass(y3, cut, fs);
%yFiltered4 = lowpass(y4, cut, fs);


% Plot the first dataset (Time-Domain)
figure;
plot(x,yFiltered, '-b'); % Plot first graph with time 
hold on;
plot(x2, yFiltered2, '-r'); % Plot second dataset with different markers

%plot(x3,yFiltered3,'-y')

%plot(x4,yFiltered4,'-y')
% A
xlabel('Time(s)');
ylabel('Amplitude (V)');
title('Amplitude vs Time for a Healthy Motor');
legend('Position 2', 'Position 3', 'Position 4', 'Position 5');
grid on;



% Hanning window before FFT reducing leakage
HannLength = length(y); % Number of samples
window = hann(HannLength); % Create a Hanning window
HannLength2 = length(y2); % Number of samples for second dataset
window2 = hann(HannLength2);

%HannLength3 = length(y3);
%window3 = hann(HannLength3);
%HannLength4 = length(y4);
%window4 = hann(HannLength4);


% Multiplying the hann window with the filtered data
windowedData = yFiltered .* window;
windowedData2 = yFiltered2 .* window2;
%windowedData3 = yFiltered3.*window3;
%windowedData4 = yFiltered4.*window4;


% Compute the FFT of the windowed signal
Y = fft(windowedData);
Y2 = fft(windowedData2);
%Y3 = fft(windowedData3);
%Y4 = fft(windowedData4);

% Shift the frequency to 0 Hz
f = (-HannLength/2:HannLength/2-1)*(fs/HannLength) ; 

% Apply fftshift to center the frequency spectrum at 0
Y_shifted = fftshift(Y);
Y_shifted2 = fftshift(Y2);
%Y_shifted3 = fftshift(Y3);
%Y_shifted4 = fftshift(Y4);


% Compute the magnitude of the FFT and scale it properly
Y_magnitude = abs(Y_shifted) * 2 / HannLength;
Y2_magnitude = abs(Y_shifted2) * 2 / HannLength2;
%Y3_magnitude = abs(Y_shifted3) * 2 / HannLength3;
%Y4_magnitude = abs(Y_shifted4) * 2 / HannLength4;

% Convert the magnitude to dB
Y_magnitude_dB = 20 * log10(Y_magnitude);
Y2_magnitude_dB = 20 * log10(Y2_magnitude);
%Y3_magnitude_dB = 20 * log10(Y3_magnitude);
%Y4_magnitude_dB = 20 * log10(Y4_magnitude);

% Plot the frequency spectrum (in dB)

figure; 
plot(f, Y_magnitude_dB,'-b'); %Magnitude in dB
hold on;
plot(f, Y2_magnitude_dB,'-r'); 
%plot(f, Y3_magnitude_dB,'-y');
%plot(f, Y4_magnitude_dB,'-y');


xlabel('Frequency (Hz)'); % X-axis label in kHz
ylabel('Magnitude (dB)');
title('Magnitude(dB) vs Frequency for a Healthy Motor at position B and C');
legend('Position 2', 'Position 3', 'Position 4','Position 5');
grid on;

