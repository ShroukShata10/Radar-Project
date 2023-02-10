clc;
Fs = 60e6;            %%sampling frequency
t = 0:1/Fs:15*10^-6;  %% Time "secondes per sample"
PRF = 0.2e6;          %%Pulse Repition Frequency
d = 0:1/(PRF):0.0001; %%Pulse Repition Interval "Recoprical of the Pulse Repition Frequency"
Pt = 1.5e6;           %%The Transmitted Peak Power 
Pr = 0.3*10^-3;       %received peak power 
At = sqrt(Pt);        %%The Amplitude of the Transmitted Pulse
Ar = sqrt(Pr);        %%The amplitude of the recieved pulse
period = 1 / PRF;     %%% 5*10^-6 seconds 
pulse_width = 18 / Fs;%%%4*10^-7
G = 10;               %%The antenna gain
sigma = 0.1;          %%The radar cross section
A = 0.5;              %%The antenna effective aperture
c = 3*10^8;           %%Light-Sound velocity

%%%%Task 1
y=@(t)(((0<(rem(t,period)))&(rem(t,period)<=pulse_width))*At);  %The Transmitted signal 
                                         %%"It is divided into intervals that have the same condition that is less than the pulse width"
                                         %%%The operating frequency which is 6 GHz is not used as the modulation is not needed to plot the transmitted signal.
figure('Name','Task 1');
plot(t,y(t),'linewidth',1);
title("The Transmitted Signal");
xlabel("Time(s)");
ylabel("Power");
grid on;
xlim([0 15*10^-6]);
ylim([0 1.02*At]);

%%%%%Task 2
Ru = c/(2*PRF);           %The Unambiguous Range
Delta_R = c*(18/Fs)/2;    %The Range Resolution "Where 18/Fs is the pulse width"

%%%%%Task 3
d = sqrt(sqrt(Pt*G*sigma*A/Pr)/(4*pi));   %distance of the object
delta_t = 2*d/c;    %the total time taken by the radar to hear back the echo of the transmitted signal
y=@(t)(((0<(rem(t,period)))&(rem(t,period)<=pulse_width))*At); %%The Transmitted Pulse
y2 = @(t)(((0<rem(t,period))&(rem(t,period)<=pulse_width))*Ar);    %The Received Signal  
                                               %The function handler is used here to call this function from another function 
noisy_y2 = awgn(y2(t-delta_t),20,'measured');    %Noisy Received Signal

figure('Name','Task 3');
subplot(2,1,1);
plot(t,y(t),'LineWidth',1);
title("Transmitted signal");
xlabel("Time(s)");
ylabel("Power");
grid on;
xlim([0 15*10^-6]);
ylim([0 1.02*At]);

subplot(2,1,2);
plot(t,noisy_y2,'LineWidth',1);
title("The Received signal");
xlabel("Time(s)");
ylabel("Power");
grid on;
xlim([0 15*10^-6]);
ylim([-0.05*Ar 1.05*Ar]);
%%%Comments
%%%The received pulse with noise is dalayed from the transmitted pulse by
%%%delta_t. Besides, the noise apprears clealy at the peak of the pulses
%%%and at zero.


%Task 4
t2 = 0:1/Fs:5*10^-6;
noisy_y2 = awgn(y2(t2-delta_t),20,'measured');
conv_rst = conv(noisy_y2,y(t2))./Fs;   %convolution of the transmitted and received signal 
                                       %The purpose of the divsion by Fs is to scale the convolution result by Fs
T = 0:1/Fs:10*10^-6;     %The delay between the 2 signals
figure('Name','Task 4');
plot(T,conv_rst,'LineWidth',1);
title("The Correlation between the Transmitted and Recived Signal");
xlabel("Time(s)");
ylabel("Power");
grid on;
xlim([0 10*10^-6]);
ylim([-0.05*Ar*At*pulse_width 1.05*Ar*At*pulse_width]);
%It is concluded from the graph that the peak is at 7.333*10^-7 seconds,
%and as a result of using the convolution function, the pulse is shifted by
%the pulse width
pulse_width = 18/60e6;
%Then, delta_t will be equal to the pulse width subtracted from the peak
%value (7.333*10^-7 - (18/60e6))
delta_t = 4.333*10^-7;
Range_task4 = delta_t*c/2; %%The distance


%Task 5
Y = awgn(y2(t-delta_t),20,'measured');
conv_rst = conv(y(t),Y)./Fs;       %convolution of the transmitted and received signals
T2 = -10*10^-6:1/Fs:20*10^-6;    %the delay between the 2 signals

figure('Name','Task 5');
subplot(2,1,1);
plot(T2,conv_rst,'linewidth',1);
title("The Correlation Using multiple pulses");
xlabel("Time(s)");
ylabel("Power");
grid on;
xlim([-10*10^-6 20*10^-6]);
ylim([-0.05*Ar*At*pulse_width*3 1.05*Ar*At*pulse_width*3]);
q = period * pulse_width; %%%The result is 300
%%%Each peek of the pulses is divided into 5 array with step equal to 300
p1 = conv_rst(1:301);
p2 = conv_rst(301:601);
p3 = conv_rst(601:901);
p4 = conv_rst(901:1201);
p5 = conv_rst(1201:1501);
Average = (p1 + p2 + p3 + p4 + p5)./5;

subplot(2,1,2);
plot(t2,Average,'linewidth',1);
title("The Avgerag Correlation Graph");
xlabel("Time(s)");
ylabel("Power");
grid on;
xlim([0 5*10^-6]);
ylim([-0.05*Ar*At*pulse_width*3 1.05*Ar*At*pulse_width*3]);
%%%It is concluded that the peak value is the same as the peak value
%%%resulting from task 4 which is 7.333*10^-7 seconds
%and, delta_t will be equal to the pulse width subreacted from the peak
%value (7.333*10^-7 - (18/60e6))
delta_t = 4.333*10^-7;
Range_Taks5 = delta_t*c/2;   %%%   64.9950
