function p=springswap_insert(p,rs,piv,s1,s2,in,hndl, s, bpos)
%Swapping the springs for the insertion sort
temp=p(s1);
p(s1)=p(s2);
p(s2)=temp;
M=20;
xbox=rs(2).r.Position(1);
xpiv=piv.Position(1);
for k=1/M:1/M:1
    slideX(p,s1,in,k,s2-s1);
    slideX(p,s2,in,k,s1-s2);
    slideBox(rs,piv,xbox,xpiv,k,s1-s2);
    [bpos, com_error]=handleupdate(hndl, s, bpos);
    drawnow
end
end

function slideX(p,i,in,k,incr)
x=i*k+(i+incr)*(1-k);
p(i).s.XData=x+sin(in*pi/2)/2.5;
p(i).s2.XData=x+sin(in*pi/2)/2.5;
p(i).m.XData=[x-0.4 x+0.4];
p(i).chk.XData=[x-0.3 x+0.3];
p(i).l.Position=[x-0.08 -0.4];
end

function rs=slideBox(rs,piv,xbox,xpiv,k,incr)
x1=xbox*(1-k)+(xbox+incr)*k;
rs(2).r.Position(1)=x1;
x2=xpiv*(1-k)+(xpiv+incr)*k;
piv.Position(1)=x2;
end