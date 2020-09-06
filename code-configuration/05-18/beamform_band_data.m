c=1520;
Up=2;
inches=.0254;
feet=12*inches;
tilt=0*pi/180;
fcen=10734;
fwid=800;
chwin=chebwin(8,30);
zpos=-[0:7]*2*feet;zpos=zpos-mean(zpos);
I=sqrt(-1);
old_type=0;
if old_type
    dr=dir('data\band*sig*.mat');
else
    dr=dir('data\2003*sig*.mat');
end
for i=1:length(dr)
    disp(sprintf('%d %s',i,dr(i).name));
end
figs=[];
peaks={};
stack_plots=input_with_default('stack plots',0);
display_title=input_with_default('display titles on figures',0);
long_geotime=input_with_default('long geotime',0);
if long_geotime
    Files=sort([2:2:20,26,1 3 7:2:17 19 21 25 29]);
    r=inputdlg({'select subset'},...
        'choose files',...
        [1,70],{sprintf('%g ',Files)});
    Files=eval(['[',r{1},']']);
else
    Files=input_with_default('enter file number',25);
end
n=1;
Bs={};
files=[];
recs=[];
for filenums=Files
    D=load(['data\',dr(filenums).name]);
    if long_geotime
        sg=1;
    else
        sg=input_with_default(sprintf('enter xmission numbers (range 1-%d)',size(D.H,3)),1);
    end
    for k=sg
        disp(n);
        d=D.H(1001:4000,:,k);
        if ~isa(D.H,'double')
            d=D.Hmax/32767*double(d);
        end
        d=resample(d,Up,1);
        %d(:,4)=(d(:,3)+d(:,5))/2;
        SR=D.SR*Up;
        hd=abs(hilbert(d(:,1)));
        %zoom_plot(hd);
        [maxs,ixs]=top_n_peaks(hd,3,18,.3);
        align_ix=ixs(1);
        d=rotate_matrix(d,align_ix-400,1);
        fd=realfft(d);
        F=[0:length(fd)-1]'*SR/length(d);
        if 1 & n==1
            d1=realifft(fd(:,1));
            noisspec=db(realfft(d1(end-1999:end)));
            noisf=[0:1000]'*SR/2000;
            zoom_plot(noisf,noisspec);
            p=get_points(2,'click 2 points for min and max frequency');
            p=p(1:2,1);
            fcen=mean(p);
            fwid=(max(p)-min(p))/4;
        end
        fwin=2.^-(((F-fcen)/fwid).^2);
        fd=fd.*repmat(fwin,1,size(fd,2));
        th=linspace(-6.8,6.8,81)'*pi/180;
        th=linspace(-12,12,81)'*pi/180;
        wmat=exp((-I*2*pi*F/SR)*([0:7]/(8/Up)));
        fd=fd.*wmat;
        B=zeros(length(d),length(th));
        for i=1:length(th)
            Kmat=(2*pi*F/c*sin(th(i)-tilt))*zpos;
            Kmat=exp(I*Kmat);
            B(:,i)=realifft((fd.*Kmat)*chwin);
        end
        B1=hilbert(B);
        t=[0:length(B1)-1]'*1000/SR;
        B1db=db(B1)';
        if k==0
            zoom_image(t,th*180/pi,B1db-max(max(B1db)))
            caxis([-40 0]);colorbar
            p=get_points(1,'click on earliest time');
            thdist=zeros(size(th,1),size(t,1));
            for i=1:size(Time_Angle,1)
                texp=exp(-((t-Time_Angle(i,1)*1000-p(1))/3).^2);
                thexp=exp(-((th*180/pi-Time_Angle(i,2))/4).^2);
                thdist=thdist+thexp*texp';
            end
            thdist=db(min(thdist,1));thdist=thdist-max(flatten(thdist));
            zoom_image(t,th*180/pi,thdist)
            caxis([-40 0]);colorbar
        end
        if 1
            B1=B1db-max(max(B1db));
        else
            B11=B1db+thdist;
            B1=B11-max(max(B11));
        end
        coodamp=get_2d_peaks(B1,-6);
        peaks{end+1}=coodamp;
        Bs{end+1}=B1;
        files(n)=filenums;
        recs(n)=k;
        n=n+1;
    end
end
p1=peaks{1};
[m,ix1]=min(p1(:,2));
for k=2:length(peaks)
    p2=peaks{k};
    [m,ix2]=min(p2(:,2));
    off=ix2-ix1;
    Bs{k}=rotate_matrix(Bs{k},off,2);
    p2(:,2)=p2(:,2)-off;
    peaks{k}=p2;
end
if stack_plots
    xlims='auto';
    while 1
        figure;
        set(gcf,'Position',[232    46   560   632])
        for k=1:length(Bs)
            B1=Bs{k};
            subplot(length(Bs),1,k)
            imagesc(t-5,th*180/pi,B1)
            axis xy
            caxis([-28 0]);
            xlim(xlims);
            if k==round(length(Bs)/2)
                %display_colorbar_with_label('amplitude re max peak, dB');
                ylabel('arrival angle, degrees');
            end
            if k==length(Bs)
                xlabel('time, ms')
            else
                set(gca,'xtick',[]);
            end
            nam=dr(files(k)).name;ix=find(nam=='_');nam(ix)=' ';
            if k==1
                if display_title
                    title(sprintf('file %d, xmit %d-%d (%s)',files(k),min(recs),max(recs),nam(1:end-4)));
                end
            end
            figs(end+1)=gcf;
            %set(gca,'Xlim',[0 8]);
            drawnow;
        end
        xlims=input_with_default('enter time scale, e.g., [5 20] or [] to quit',[5 20]);
        if length(xlims)==0
            break
        end
    end
else
    for k=1:length(Bs)
        B1=Bs{k};
        figure;
        imagesc(t-5,th*180/pi,B1)
        axis xy
        xlabel('time, msec');
        ylabel('arrival angle, degrees');
        caxis([-28 0]);
        display_colorbar_with_label('amplitude re max peak, dB');
        xlabel('time, ms')
        ylabel('angle, deg')
        nam=dr(files(k)).name;ix=find(nam=='_');nam(ix)=' ';
        if display_title
            title(sprintf('file %d, xmit %d (%s)',files(k),recs(k),nam(1:end-4)));
        end
        figs(end+1)=gcf;
        %set(gca,'Xlim',[0 8]);
        drawnow;
    end
end
return
figure
hold on
for i=1:length(peaks)
    p=peaks{i};
    ix=find(p(:,3)>-24&abs(th(p(:,1)))<30*pi/180);
    p=p(ix,:);
    scatter3(th(p(:,1))*180/pi,t(p(:,2)),repmat(i,size(p,1)),5,p(:,3),'filled')
end
colorbar

return
allfigs(figs);
return
M=movie_from_figs(figs);
return
figure;
set(gcf,'Position',[232   133   120   507])
imagesc([0 1],[-26 0],linspace(-26,0,300)'*ones(1,2));axis xy
display_colorbar_with_label('relative amplitude, dB');