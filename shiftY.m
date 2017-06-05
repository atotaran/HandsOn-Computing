function shiftY(p,rs,i,a,hndl, s, bpos)
%this function is used for shifting the springs and comparison boxes on the
%y-direction
M=10;
a2=a/M;
b=2;
for k=1:M
    shiftone(p,i,a2);
    rs(b).r.Position=rs(b).r.Position+[0 a2 0 0];
    [bpos, com_error]=handleupdate(hndl, s, bpos);
    drawnow
end

end
function shiftone(p,i,a)
p(i).s.YData=p(i).s.YData+a;
p(i).s2.YData=p(i).s2.YData+a;
p(i).m.YData=p(i).m.YData+a;
end