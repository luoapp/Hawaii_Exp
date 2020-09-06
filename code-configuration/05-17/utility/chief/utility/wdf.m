function w=wdf(s,t)
% Wigner distribution function
% W(t,omiga)=int( s(t+tao/2) * conj(s(t+tao/2)) * exp(-j * omiga * tao) d(tao) ) 
% modified wigner distribution function
% MW(t,omiga)=1 / (2*pi) * int( W(t_ , omiga_) * H(t_ - t, omiga_ - omiga) d(t_)d(omiga_) ) 
% H(t,omiga)=exp(-t*t/alpha - t*t/beta), alpha =100, beta=125???!!!!!
%---------------------------------------------
% parameters: s: signal, t: associated time; length(s)=length(t)
T=length(s);
w=zeros(T,T+1);
delta_t=t(2)-t(1);
delta_tao=2*delta_t;
tao_=[0:1:T];
tao=2*delta_t*tao_;

for i=1:2:T
    for i2=0:1:T
        if (i+i2>T | i-i2 <1) ins_s(i2+1)=0;
        else
            ins_s(i2+1)=s(i+i2)*conj(s(i-i2));
        end
    end
    w(i,:)=fft(ins_s);
end

                                    