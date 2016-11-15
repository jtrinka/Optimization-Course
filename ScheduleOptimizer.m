function [NewSchedule] = ScheduleOptimizer()

%every shift has one doctor on call

%Read in data for preferred days off.
Data = xlsread('ScheduleGenerator.xlsm','PreferredTime');
Data2 = xlsread('ScheduleGenerator.xlsm','NeededTime');
Data3 = xlsread('ScheduleGenerator.xlsm','MaxNumberofShifts');








currentrow = 1;
jmax = 28;
imax = length(Data(:,1))-1;

%One physician scheduled each day constraints.

%One physician scheduled each day constraints.
for j=1:jmax
    for i=1:imax
        
        
        A(currentrow,ijToIndex(i,j,jmax))=-1;
       b(currentrow)=-1; 
        
    end
    
    currentrow=currentrow+1;
end



%No physician scheduled for consecutive days constraint.
n=0;

for k=1:imax
n=n+1;
    
    
for j=1:jmax -1
    
   for i=n
        
    A(currentrow,ijToIndex(i,j,jmax))=1;
    A(currentrow,ijToIndex(i,j,jmax)+1)=1;
    b(currentrow)=1; 
    
    
  end
  
   currentrow=currentrow+1;

end
 


end


%No physician scheduled for 3 shifts per seven day period constraint.
n=0;


for k=1:imax
    
    n=n+1;
for j=1:jmax/4
    
    
    for i=n
        
        
         A(currentrow,ijToIndex(i,j,jmax))=1;
         A(currentrow+1,ijToIndex(i,j,jmax)+1)=1;
         A(currentrow+2,ijToIndex(i,j,jmax)+2)=1;
         A(currentrow+3,ijToIndex(i,j,jmax)+3)=1;
         A(currentrow+4,ijToIndex(i,j,jmax)+4)=1;
         A(currentrow+5,ijToIndex(i,j,jmax)+5)=1;
         A(currentrow+6,ijToIndex(i,j,jmax)+6)=1;
         A(currentrow+7,ijToIndex(i,j,jmax)+7)=1;
         A(currentrow+8,ijToIndex(i,j,jmax)+8)=1;
         A(currentrow+9,ijToIndex(i,j,jmax)+9)=1;
         A(currentrow+10,ijToIndex(i,j,jmax)+10)=1;
         A(currentrow+11,ijToIndex(i,j,jmax)+11)=1;
         A(currentrow+12,ijToIndex(i,j,jmax)+12)=1;
         A(currentrow+13,ijToIndex(i,j,jmax)+13)=1;
         A(currentrow+14,ijToIndex(i,j,jmax)+14)=1;
         A(currentrow+15,ijToIndex(i,j,jmax)+15)=1;
         A(currentrow+16,ijToIndex(i,j,jmax)+16)=1;
         A(currentrow+17,ijToIndex(i,j,jmax)+17)=1;
         A(currentrow+18,ijToIndex(i,j,jmax)+18)=1;
         A(currentrow+19,ijToIndex(i,j,jmax)+19)=1;
         A(currentrow+20,ijToIndex(i,j,jmax)+20)=1;
         A(currentrow+21,ijToIndex(i,j,jmax)+21)=1;
         
         b(currentrow)=3;
         b(currentrow+1)=3;
         b(currentrow+2)=3;
         b(currentrow+3)=3;
         b(currentrow+4)=3;
         b(currentrow+5)=3;
         b(currentrow+6)=3;
         b(currentrow+7)=3;
         b(currentrow+8)=3;
         b(currentrow+9)=3;
         b(currentrow+10)=3;
         b(currentrow+11)=3;
         b(currentrow+12)=3;
         b(currentrow+13)=3;
         b(currentrow+14)=3;
         b(currentrow+15)=3;
         b(currentrow+16)=3;
         b(currentrow+17)=3;
         b(currentrow+18)=3;
         b(currentrow+19)=3;
         b(currentrow+20)=3;
         b(currentrow+21)=3;
         
         
                                            
    end
    
    
end
currentrow=currentrow+jmax-6;
end



%Each physician should have at least two days off between shifts. RHS must
%be one here.
n=0;



for k=1:imax
n=n+1;
    
    
for j=1:jmax -2
    
   for i=n
        
    A(currentrow,ijToIndex(i,j,jmax))=1;
    A(currentrow,ijToIndex(i,j,jmax)+2)=1;
    b(currentrow)=1; 
    
    



 



        
        
        
 
    
    %softened
    A(currentrow,ijToIndex(i,j,jmax)+(imax*jmax))=-1;
    
    
  end
  
   currentrow=currentrow+1;
  

end
 


end




%Honoring preferred physician days off constraint. %RHS is 0

R=29;
C=1;
for i=1:imax
    
    for j=1:jmax
    
   A(currentrow,ijToIndex(i,j,jmax)) = Data(i+1,j);
   b(currentrow)=0;
   
   %Add in the binary auxilliary variables to soften
   if j==jmax
       
       A(currentrow,ijToIndex(i,j,jmax)+(imax*jmax+1)*2-R+C-2)=-1;
           R=R+28;
           C=C+1;
   end
    
    end
    currentrow=currentrow+1;
end




%Max number of shifts per two week pay period. Just 1 to 14 and then 15 to
%28 don't soften
maxshiftvec=Data3;
n=0;
for i=1:imax
   n=n+1; 
    
  for j=1:jmax/2
      
   A(currentrow,ijToIndex(i,j,jmax))=1;
   A(currentrow+1,ijToIndex(i,j,jmax)+14)=1;
   b(currentrow)=maxshiftvec(i);
   b(currentrow+1)=maxshiftvec(i);
   
   
   
   
   
   
      
      
      
  end
  
      
  
   currentrow=currentrow+2;
  
end


% Time off needed constraints

%RHS is 0
R=29;
C=1;
for i=1:imax
    
    for j=1:jmax
        
        
        A(currentrow,ijToIndex(i,j,jmax))=Data2(i+1,j);
        b(currentrow)=0;
        %soften
        if j==jmax
        A(currentrow,ijToIndex(i,j,jmax)+(imax*jmax+1)*2+imax-R+C-2)=-1;
         R=R+28;
           C=C+1;
        end
        
    end
    
    currentrow=currentrow+1;
end

%Equitable Distribution


for i=1:imax
    
    for j=1:jmax
        
        
        A(currentrow,ijToIndex(i,j,jmax))=-1;
        A(currentrow+1,ijToIndex(i,j,jmax))=1;
        
       
        
      
            
            
        
        b(currentrow)=-3;
        b(currentrow+1)=6;
        
       
        
       
        
    end
    currentrow=currentrow+2;
end



b=b';
Aeq= [];
beq=[];


[m,n]=size(A);
Intcon=1:n;
% f=ones(1,n);
DecisionVariables=ones(1,(jmax*imax));
NeededTimeOffPenalty=6*ones(1,imax);
WantedTime=2*ones(1,imax);
ConsecutiveDays=ones(1,(jmax*imax-1));
f=[DecisionVariables, ConsecutiveDays, WantedTime, NeededTimeOffPenalty];
NormVar=ones((m-(imax*2)):1);
IntVar=5*ones((imax*2):1); % they can work 5 days that they have preferred or requested off without breaking code. 
ub=[NormVar, IntVar];
lb=zeros(n,1);





sched= intlinprog(f,Intcon,A,b,Aeq,beq,lb,ub);

NewSchedule=reshape(sched(1:imax*jmax),[jmax,imax])';

File='ScheduleGenerator.xlsm';
xlswrite(File,NewSchedule,'Schedule Sheet','E2')





end