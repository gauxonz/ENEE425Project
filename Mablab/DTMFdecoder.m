function result = DTMFdecoder(WaveFile,Method)
%read file
[RawWave,Fs]=wavread(WaveFile);

% Prefileter
f1=700;f3=1700;
fsl=620;fsh=1800;
rp=0.1;rs=30;
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

%set figure position
set(gcf,'Position',[0 20 1200 500]);
set(gca,'Position',[0 0 1 1]);
figure_FontSize=8;
set(get(gca,'XLabel'),'FontSize',figure_FontSize,'Vertical','top');
set(get(gca,'YLabel'),'FontSize',figure_FontSize,'Vertical','middle');
set(findobj('FontSize',10),'FontSize',figure_FontSize);
set(findobj(get(gca,'Children'),'LineWidth',0.5),'LineWidth',2);

%draw raw wave
subplot(2,a(1),1:a(1))
plot(RawWave);
title('DTMF Raw Input');xlabel('Time');
ylabel('Amplitude');grid;

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
    else
        diplay('ERROR: invalid method!');
    end
    %do fft and draw
    FFTWave=abs(fft(FiltedWave...
        (SigBegin:SigEnd),2*HalfSampleLength));
    subplot(2,a(1),a(1)+i)
    plot(Fs/length(FFTWave).*(1:length(FFTWave)/2),FFTWave(1:length(FFTWave)/2));
    title('FFT');xlabel('Continue Freq');
    ylabel('Amplitude');grid;
end

disp( ['The code is ' result]) 
end
