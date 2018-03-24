clc;
clearvars;


%---------------------------------------------------------------------------
% Lab 8 and 9: Encoding and Decoding Touch-Tone (DTMF) Signals
%---------------------------------------------------------------------------
% 3. Warm-up: DTMF Synthesis
%---------------------------------------------------------------------------
% 3.1 DTMF Dial Function
%---------------------------------------------------------------------------

dial_string = '123456789ABCD';
fs = 8000;

[dial_tone dial_freqs] = dtmfdial(dial_string,fs);

figure(1)
plot(dial_tone)

%---------------------------------------------------------------------------
% When an invalid character is included in the dialstring                 
% the dtmfdial() will just back out and only include the character signals
% dialed before the invalid character                                     
%---------------------------------------------------------------------------

dial_string = '123eABC';
fs = 8000;

dial_tone = dtmfdial(dial_string,fs);

figure(2)
plot(dial_tone)

%---------------------------------------------------------------------------
% 3.2 Simple Bandpass Filter Design
%---------------------------------------------------------------------------
% a.
%---------------------------------------------------------------------------

omega_c = 0.2*pi;
L = 51;
Beta = 2/(L+1);
n = 0:L;
hn = Beta*cos(omega_c*n);
freq_range = -pi:pi/fs:pi;

[H, w] = freqz(hn,1,freq_range);

figure(3)
plot(w, abs(H))

%---------------------------------------------------------------------------
% b.
%---------------------------------------------------------------------------

passband = find(abs(H)>.707);
pb_length = length(passband);
passband_possitive = passband(1+(pb_length/2):pb_length);
pb_length = pb_length/2;
disp('3.2 part b and c');
disp(['The pass band length is ', num2str(pb_length), ' Hz']);

%---------------------------------------------------------------------------
% c.
%---------------------------------------------------------------------------

freq_components_passed = freq_range(passband_possitive)*(fs/pi);
pass_start = freq_components_passed(1);
pass_end = freq_components_passed(pb_length);

disp(['The pass band starting corner frequency is ', num2str(pass_start), ' Hz']);
disp(['The pass band ending corner frequency is ', num2str(pass_end), ' Hz']);
disp(' ');

%---------------------------------------------------------------------------
% 4. Lab Exercises: DTMF Decoding
%---------------------------------------------------------------------------
% 4.1 Simple Bandpass Filter Design: dtmfdesign.m
%---------------------------------------------------------------------------
% a. and b. are in the dtmfdesign.m file.
%---------------------------------------------------------------------------
% d.
%---------------------------------------------------------------------------

center_frequencies = dial_freqs;
L = 40;
dtfm_filter_matrix = dtmfdesign(dial_freqs, L, fs);
freq_range = 0:pi/fs:pi;
maxH = []; %used to find peaks of frequency response

figure(4);
hold on;
for i = 1:length(dial_freqs)
    [H, w] = freqz(dtfm_filter_matrix(i,:),1,freq_range);
    maxH = [maxH find(H == max(H))/(2)];
    plot(w*fs/(2*pi), abs(H))
end
hold
passband1 = find(abs(H)>.707);

figure(5);
maxH = [0 maxH 0];
stem(maxH);
for i = 2:(length(maxH)-1)
    text(i-0.3,maxH(i)+100,num2str(maxH(i)));
end
%---------------------------------------------------------------------------
% e.
%---------------------------------------------------------------------------

L = 80;
dtfm_filter_matrix = dtmfdesign(dial_freqs, L, fs);
maxH = [];

figure(6);
hold on;
for i = 1:length(dial_freqs)
    [H, w] = freqz(dtfm_filter_matrix(i,:),1,freq_range);
    maxH = [maxH find(H == max(H))/(2)];
    plot(w*fs/(2*pi), abs(H))
end
hold
passband2 = find(abs(H)>.707);

figure(7);
maxH = [0 maxH 0];
stem(maxH);
for i = 2:(length(maxH)-1)
    text(i-0.3,maxH(i)+100,num2str(maxH(i)));
end

pb1_length = length(passband1);
pb2_length = length(passband2);
disp('4.3 part e');
disp(['Pass band width for L=40 for last filter is ', num2str(pb1_length), ' Hz']);
disp(['Pass band width for L=80 for last filter is ', num2str(pb2_length), ' Hz']);

%---------------------------------------------------------------------------
% e.
%---------------------------------------------------------------------------
