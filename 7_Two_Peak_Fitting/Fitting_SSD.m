clear;clc;

inpath = 'X:\Chenghang\4_Color\SSD_Large_and_Small_Homer1\';
a = readmatrix([inpath 'Sub_volume.csv']);
a(:,6) = [];
%%
%for i = 1:36
i=15;
temp_a = a(:,i);
for j =numel(temp_a):1
    if isnan(temp_a(j))
        temp_a(j)=[];
    end
end

temp_a = log10(temp_a*0.000000001);
%end
%Smooth the histogram.
h = histfit(temp_a,40,'kernel');
x = h(2).XData;
y = h(2).YData;

op = fitoptions('gauss2');
%Set upper/lower boundary of [a1, b1, c1, a2, b2, c2].
op.Lower = [0,-5,0,0,-3,0];
op.Upper = [Inf,-3,Inf,Inf,0,Inf];
[f gof] = fit(x',y','gauss2',op);
%%
%f
%gof

%hold on
%plot(f,'b');
%%
f1 = @(x) f.a1*exp(-((x-f.b1)/f.c1)^2);
f2 = @(x) f.a2 *exp(-((x-f.b2)/f.c2)^2);
hold on
fplot(f1,[-5,-1],'g');
hold on
fplot(f2,[-5,-1],'b');
%%
lo_thre = f.b1;
hi_thre = f.b2;

cubic_lo_line = nthroot(10^(lo_thre+9),3);
sphere_lo_diameter = nthroot(10^(lo_thre+9)/1.333/3.14159,3)*2;
cubic_hi_line = nthroot(10^(hi_thre+9),3);
sphere_hi_diameter = nthroot(10^(hi_thre+9)/1.333/3.14159,3)*2;
disp('cubic diameter of small SSDs');
disp(cubic_lo_line)
disp('sphere diameter of small SSDs');
disp(sphere_lo_diameter)
disp('cubic diameter of large SSDs');
disp(cubic_hi_line)
disp('sphere diameter of large SSDs');
disp(sphere_hi_diameter)
