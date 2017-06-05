function p=springswap(p,s1,s2,in,hndl, s, bpos)
%Basic funtion for swapping the springs
temp=p(s1);
p(s1)=p(s2);
p(s2)=temp;
M=20;
for k=1/M:1/M:1
    slideX(p,s1,in,k,s2-s1);
    slideX(p,s2,in,k,s1-s2);
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