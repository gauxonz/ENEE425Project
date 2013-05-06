function result = DTMFdecoder(WaveFile,Method,Graph)
%read file
if nargin==1,Method='FFT';Graph='graph_off';end
if nargin==2,Graph='graph_off';end
[RawWave,Fs,Bits]=wavread(WaveFile);
assert(strcmp(Method,'FFT')||strcmp(Method,'Filter'),...
    'ERROR: invalid method! The method shoud be ''FFT'' or ''Filter''.');
assert(strcmp(Graph,'graph_on')||strcmp(Graph,'graph_off'),...
    'ERROR: invalid Graph opintion! it shoud be ''graph_on'' or ''graph_off''.');

if strcmp(Graph,'graph_on'),sound(RawWave,Fs,Bits);end

% Prefileter
f1=690;f3=1700;
fsl=630;fsh=1800;
rp=1;rs=15;
wp1=2*pi*f1/Fs;
wp3=2*pi*f3/Fs;
wsl=2*pi*fsl/Fs;
wsh=2*pi*fsh/Fs;
wp=[wp1 wp3];
ws=[wsl wsh];
[n,wn]=cheb1ord(ws/pi,wp/pi,rp,rs);
[bz1,az1]=cheby1(n,rp,wp/pi);
FiltedWave=filter(bz1,az1,RawWave);
FiltedWave(1:100)=0;

%position signal
HalfSampleLength=1024;
EffPosition = WaveSpliter(FiltedWave);
a=size(EffPosition);

%draw raw wave
if strcmp(Graph,'graph_on')

set(gcf,'Position',[0 20 1200 500]);
set(gca,'Position',[0 0 1 1]);
figure_FontSize=8;
set(get(gca,'XLabel'),'FontSize',figure_FontSize,'Vertical','top');
set(get(gca,'YLabel'),'FontSize',figure_FontSize,'Vertical','middle');
set(findobj('FontSize',10),'FontSize',figure_FontSize);
set(findobj(get(gca,'Children'),'LineWidth',0.5),'LineWidth',2);

subplot(2,a(1),1:a(1))
plot(RawWave);
title('DTMF Raw Input');xlabel('Time');
ylabel('Amplitude');grid;
end

for i=1:a(1)
    %decode single 
    MidSig = ceil((EffPosition(i,1)+EffPosition(i,2))/2);
    SigBegin = MidSig-ceil((EffPosition(i,2)-EffPosition(i,1))*3/10);
    SigEnd = MidSig+ceil((EffPosition(i,2)-EffPosition(i,1))*3/10);

    if strcmp(Method,'FFT')
        result(i) = DTMFdecoder_single_FFT(...
            FiltedWave(SigBegin:SigEnd),Fs);
    elseif strcmp(Method,'Filter')
        result(i) = DTMFdecoder_single_Filter(...
            FiltedWave(SigBegin:SigEnd),Fs);
    end
    %do fft and draw
    if strcmp(Graph,'graph_on')
    FFTWave=abs(fft(FiltedWave...
       (SigBegin:SigEnd),2*HalfSampleLength));    
    subplot(2,a(1),a(1)+i)
    plot(Fs/length(FFTWave)/2.*(1:length(FFTWave)/2)...
        ,FFTWave(1:length(FFTWave)/2));
    title('FFT');xlabel('Continue Freq');
    ylabel('Amplitude');grid;
    end
end

disp( ['The code is ' result]) 
end

