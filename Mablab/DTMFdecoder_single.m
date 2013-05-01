function ResultCode = DTMFdecoder_single(PureWave,Fs)
Rp=0.5;
As=25;
Fpass = 1000;
Fstop = 1100;
wp = 2*pi*Fpass/Fs;
ws = 2*pi*Fstop/Fs;
[N,Wn]=cheb1ord(wp/pi,ws/pi,Rp,As);

[bl,al]=cheby1(N,Rp,Wn);
RawWaveFilt_L=filter(bl,al,PureWave);
FFTWave_L=fft(RawWaveFilt_L,length(PureWave));
FFTWave_L_Mag=abs(FFTWave_L(1:ceil(length(PureWave)/2)));

[bh,ah]=cheby1(N,Rp,Wn,'high');
RawWaveFilt_H=filter(bh,ah,PureWave);
FFTWave_H=fft(RawWaveFilt_H,length(PureWave));
FFTWave_H_Mag=abs(FFTWave_H(1:ceil(length(PureWave)/2)));

m=max(abs(FFTWave_L_Mag));n=max(abs(FFTWave_H_Mag));
o=find(m==FFTWave_L_Mag);p=find(n==FFTWave_H_Mag);
j=((o-1)*Fs)/length(PureWave);
k=((p-1)*Fs)/length(PureWave);

if j<=732.59 & k<=1270.91;
    ResultCode = '1';
   elseif j<=732.59 & k<=1404.73;
    ResultCode = '2';
   elseif j<=732.59 & k<=1553.04;
    ResultCode = '3';
   elseif j<=732.59 & k>1553.05;
    ResultCode = 'A';
   elseif j<=809.96 & k<=1270.91;   
    ResultCode = '4';
   elseif j<=809.96 & k<=1404.73;
    ResultCode = '5';
   elseif j<=809.96 & k<=1553.04;
    ResultCode = '6';   
   elseif j<=809.96 & k>1553.05;
    ResultCode = 'B';  
   elseif j<=895.39 & k<=1270.91;
    ResultCode = '7';  
   elseif j<=895.39 & k<=1404.73;
    ResultCode = '8';  
   elseif j<=895.39 & k<=1553.04;
    ResultCode = '9';  
   elseif j<=895.39 & k>1553.05;      
    ResultCode = 'C';    
   elseif j>895.40 & k<=1270.91;   
    ResultCode = '*';  
   elseif j>895.40 & k<=1404.73;  
    ResultCode = '0';  
   elseif j>895.40 & k<=1553.04;  
    ResultCode = '#';  
   elseif j>895.40 & k>1553.05;  
    ResultCode = 'D';  
end