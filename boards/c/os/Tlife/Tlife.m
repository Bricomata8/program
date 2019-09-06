Efull=12.5;
Efail=3.528;
Ef=4;
Ps=0.12*10^-3;
Twub=0.011;
Tdata=0.0077;
Tack=0.004;
Pr=24.51*3*10^-3;
%xci=1:0.5:10;40
xci=2;
Psd=0.141;
EtPsd=Psd*Twub+Psd*Tdata+Pr*Tack;
Pw=0.284*10^-3;
Psr=0.073;
Ttx=Twub+Tdata+Tack;
PsenderPsd=Pw+xci*Psr*Twub+xci*EtPsd+(1-xci*Twub-xci*Ttx)*Ps
EtPsr=Psr*Twub+Psr*Tdata+Pr*Tack;
PsenderPsr=Pw+xci*Psr*Twub+xci*EtPsr+(1-xci*Twub-xci*Ttx)*Ps
Prd=Psr;
ErPrd=Pr*Tdata+Prd*Tack;
Trx=Tdata+Tack;
Prelay1=Pw+xci*Psr*Tack+(1-xci*Tack)*Ps+xci*ErPrd+xci*EtPsr-(xci*Ttx+xci*Trx)*Ps
Prelay0=Pw+xci*Psr*Tack+(1-xci*Tack)*Ps
PdestDirect=Pw+xci*Pr*Tdata+xci*Psd*Tack+(1-xci*Tack-xci*Tdata)*Ps;
PdestRelay=Pw+xci*Pr*Tdata+xci*Psr*Tack+(1-xci*Tack-xci*Tdata)*Ps
TlifeDirect=(Efull-Efail)./PsenderPsd;
Trelay=min((Efull-Efail)./PsenderPsr , (Efull-Ef)./Prelay1);
Tdirect=(Efull-PsenderPsr.*Trelay-Efail)./PsenderPsd;
TlifeRelay=Trelay+Tdirect;
M=3;
Trelay2=min((Efull-Efail)./PsenderPsr , (Efull-Ef)*M./Prelay1);
TlifeRelay2=Trelay2+Tdirect;
PsenderPsd2=Pw+xci*EtPsd+(1-xci*Ttx)*Ps;
TlifeDirect2=(Efull-Efail)./PsenderPsd2;
plot(xci,TlifeDirect,'g',xci,TlifeRelay,xci,TlifeRelay2)
Erestante=Prelay1.*(Trelay2./M);
Eres=Efull- Erestante;
Erestante2=Prelay1.*(Trelay2);
Eres2=Efull- Erestante2;
Trelay2;
plot(xci,TlifeDirect/60,'g',xci,TlifeRelay/60,'y',xci,TlifeRelay2/60,'r',xci,TlifeDirect2/60,'b')
%plot(xci,Eres2);
%subplot (2,1,1);
%plot(xci,Eres2);
%subplot (2,1,2);
%plot(xci,Eres);
Eres1node=PsenderPsr.*Trelay;
Er1node=Efull-Eres1node;
%plot(xci,Er1node)

