function[coldif]=cielabde(data1,data2)

%Calculates CIELAB color difference for colors 1 and 2 (Minolta
%measurements)
%Output: Color difference + components

%Let's use our CIELAB color coordinate function
%Note: CIELAB function uses function for calculating tristimulus values

coord1=cielab(data1);
%Let's separate variables
L1=coord1(1);   %L*
a1=coord1(2);   %a*
b1=coord1(3);   %b*
C1=coord1(4);   %Chroma
h1=coord1(5);   %Hue-angle

coord2=cielab(data2);
L2=coord2(1);   %L*
a2=coord2(2);   %a*
b2=coord2(3);   %b*
C2=coord2(4);   %Chroma
h2=coord2(5);   %Hue-angle

%Delta-L*
DL=L2-L1;
%Delta-a*
Da=a2-a1;
%Delta-b
Db=b2-b1;
%Delta-E
DE=sqrt(DL^2+Da^2+Db^2);

%Chorma-hue system
%Delta-C*
DC=C2-C1;
%Delta-H*
DH=sqrt(DE^2-DL^2-DC^2);


%Sign of Delta-H
p=h2-h1;			%h1 and h2 hue angles
if p==0			%Just in case h2=h1... but then Delta-H is zero
	sign=1;
else
	if h2-h1>pi 		%If increase is more than 180°…
		p=p-2*pi;	%...it is actually decrease.
	end
	sign=p/abs(p);		% 1 or -1	
end
DH=DH*sign;

coldif=[DE,DL,Da,Db,DC,DH];