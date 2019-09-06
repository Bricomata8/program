Efull=12.5;
Efail=3.528;
Ef=4;
Ps=0.12*10^-3;
Twub=0.011;
Tdata=0.0077;
Tack=0.004;
Pr=24.51*3*10^-3;
xci=1:120;
%Psd=0.141;
EtPsd=Psd*Twub+Psd*Tdata+Pr*Tack;
Pw=0.284*10^-3;
Psr=0.073;
Ttx=Twub+Tdata+Tack;
PsenderPsd=Pw+xci/60*Psr*Twub+xci/60*EtPsd+(1-xci/60*Twub-xci/60*Ttx)*Ps;
EtPsr=Psr*Twub+Psr*Tdata+Pr*Tack;
PsenderPsr=Pw+xci/60*Psr*Twub+xci/60*EtPsr+(1-xci/60*Twub-xci/60*Ttx)*Ps;
Prd=Psr;
ErPrd=Pr*Tdata+Prd*Tack;
Trx=Tdata+Tack;
Prelay1=Pw+xci/60*Psr*Tack+(1-xci/60*Tack)*Ps+xci/60*ErPrd+xci/60*EtPsr-(xci/60*Ttx+xci/60*Trx)*Ps;
Prelay0=Pw+xci/60*Psr*Tack+(1-xci/60*Tack)*Ps;
PdestDirect=Pw+xci/60*Pr*Tdata+xci/60*Psd*Tack+(1-xci/60*Tack-xci/60*Tdata)*Ps;
PdestRelay=Pw+xci/60*Pr*Tdata+xci/60*Psr*Tack+(1-xci/60*Tack-xci/60*Tdata)*Ps;
TlifeDirect=(Efull-Efail)./PsenderPsd;
Trelay=min((Efull-Efail)./PsenderPsr , (Efull-Ef)./Prelay1);
Tdirect=(Efull-PsenderPsr.*Trelay-Efail)./PsenderPsd;
TlifeRelay=Trelay+Tdirect;
M=3;
Trelay2=min((Efull-Efail)./PsenderPsr , (Efull-Ef)*M./Prelay1);
TlifeRelay2=Trelay2+Tdirect;
PsenderPsd2=Pw+xci/60*EtPsd+(1-xci/60*Ttx)*Ps;
TlifeDirect2=(Efull-Efail)./PsenderPsd2;
%plot(xci,TlifeDirect,'g',xci,TlifeRelay,xci,TlifeRelay2)
Erestante=Prelay1.*(Trelay2./M);
Eres=Efull- Erestante;
Erestante2=Prelay1.*(Trelay2);
Eres2=Efull- Erestante2;
Trelay2;

PsenderDirectExp=zeros (1,5);
%plot(xci,TlifeDirect/60,'g',xci,TlifeRelay/60,'y',xci,TlifeRelay2/60,'r',xci,TlifeDirect2/60,'b')
%plot(xci,Eres2);
%subplot (2,1,1);
%plot(xci,Eres2);
%subplot (2,1,2);
%plot(xci,Eres);
Eres1node=PsenderPsr.*Trelay;
Er1node=Efull-Eres1node;
%plot(xci,Er1node)
%plot(xci1,rPsender)
plot(xci2,dPsender2,'*',xci2,rPsender2,'+',xci2,dPrelay2,'*',xci2,rPrelay2,'*',xci2,dPdest3,'*',xci2,rPdest3,'*',xci,PsenderPsd,'b',xci,PsenderPsr,'r',xci,Prelay0,'y',xci,Prelay1,'g',xci,PdestDirect, xci,PdestRelay);
%plot (xci2,dPdest)