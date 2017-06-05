function serwrite(s,wData1,wData2)
%This function helps write to serial which then is read by the Simulink
%model and taken as the spring stiffness coefficients
wHead='S';
wTerm='E';

for i=1:100
    fwrite(s,wHead,'int8')
    fwrite(s,wData1,'int32')
    fwrite(s,wData2,'int32')
    fwrite(s,wTerm,'int8');
end