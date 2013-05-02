% [RawWave,Fs]=wavread('realrec1');
% %[RawWaveHaed,Fs]=wavread('realrec1',100);
% %RawWave(1:length(RawWaveHaed))=RawWave(1:length(RawWaveHaed))-RawWaveHaed;
% 
%  f1=700;f3=1700;%?????????
% fsl=620;fsh=1800;%?????????
% rp=0.1;rs=15;%?????DB???????DB?
% % Fs=2000;%???
% %
% wp1=2*pi*f1/Fs;
% wp3=2*pi*f3/Fs;
% wsl=2*pi*fsl/Fs;
% wsh=2*pi*fsh/Fs;
% wp=[wp1 wp3];
% ws=[wsl wsh];
% %
% % ??????????
% [n,wn]=cheb1ord(ws/pi,wp/pi,rp,rs);
% [bz1,az1]=cheby(n,rp,wp/pi);
% y=filter(bz1,az1,RawWave);
% 
% y(1:100)=0;
% 
% %  f1=10;f3=650;%?????????
% %  fsl=100;fsh=630;%?????????
% %  rp=0.1;rs=30;%?????DB???????DB?
% % % Fs=2000;%???
% % %
% % wp1=2*pi*f1/Fs;
% % wp3=2*pi*f3/Fs;
% % wsl=2*pi*fsl/Fs;
% % wsh=2*pi*fsh/Fs;
% % wp=[wp1 wp3];
% % ws=[wsl wsh];
% % %
% % % ??????????
% % [n,wn]=cheb1ord(ws/pi,wp/pi,rp,rs);
% % [bz1,az1]=cheby1(n,rp,wp/pi,'stop');
% % y=filter(bz1,az1,RawWave);
% 
% 
% % Rp=0.5;
% % As=10;
% % Fpass = 600;
% % Fstop = 680;
% % wp = 2*pi*Fpass/Fs;
% % ws = 2*pi*Fstop/Fs;
% % [N,Wn]=cheb1ord(wp/pi,ws/pi,Rp,As);
% % [bh,ah]=cheby1(N,Rp,Wn,'high');
% % y=filter(bh,ah,y);
% 
% Env = envelope([1:length(y)],abs(y),400,'top');
% %Env = envelope([1:length(y)],abs(Env),200,'top');
% Avr = mean(abs(Env))/1.5;
% hold on
% %plot(abs(RawWave));
% p=plot(Env);
% plot([1:length(Env)],Avr);
% set(p,'Color','red','LineWidth',1)
% hold off

[zewave Freq]=wavread('dail5');
zewave=zewave(:)'; 
DTMFCell=...
    {...
    'Tone1/Tone2'	'1209'	'1336'	'1477'	'1633';...
            '697'	'1'     '2'     '3'     'A';...
            '770'	'4'     '5'     '6'     'B';...
            '852'	'7'     '8'     '9'     'C';...
            '941'	'*'     '0'     '#'     'D'...
    };
Code=DTMFCell( 2:end,2:end)';
Tone1=cellfun(@(x) str2num(x), DTMFCell(1,2:end));
Tone2=cellfun(@(x) str2double(x), DTMFCell(2:(end-1),1)');
[ToneMat1 ToneMat2] =ndgrid(Tone1,Tone2);
k=1;
figure(1);
TD=.5; % tone duration in second
subplot(3,4,1)
k=1;
MaxAmplitude=zeros(numel(Tone1)*numel(Tone2),1);
for TonePair=[ToneMat1(:)';ToneMat2(:)']
    ComplexTone=(cos(2*pi*( (0:1/Freq:TD) *TonePair(1)))+j*cos(2*pi*( (0:1/Freq:TD) *TonePair(2))));    
    subplot(3,4,k)
    XcorrData=xcorr(zewave,ComplexTone);
    Amplitude=(abs(hilbert(real(XcorrData)))+abs(hilbert(imag(XcorrData))));
    plot(Amplitude)
    MaxAmplitude(k)=max(Amplitude);
k=k+1;
       legend([ num2str(TonePair(1)) ',' num2str(TonePair(2))])
end   
[val Indx]=max(MaxAmplitude);
subplot(3,4,Indx)
text(.5,.5,'this is it', 'units', 'normalized')
disp( ['The code is ' Code{Indx}]) 