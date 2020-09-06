% function interactive_extract_matched_filter_signals
global Pts
if input_with_default('use existing working file list (0=no, 1=yes)? ',1)
    try
        load working_file_list
        if input_with_default('use new data file directory (1=yes)?',0)
            Dir=uigetdir;
            if length(Dir)~=0
                save working_file_list Dir -append
            else
                error('no directory chosen - rerun the function');
            end
        end
    catch
    end
else
    Dir=uigetdir;
    drspec=input_with_default('enter file specs to read, with no extension (e.g., 20030701T03*) ','200307\d\dT\d*');
    %%%%------------original code by steve
    %     
    %     dr=dir(sprintf('%s\\*.daq',Dir));
    %     drs={};
    %     for i1=1:length(dr)
    %         [toks,tokf,tokt]=regexpi(dr(i1).name,[drspec,'.daq']);
    %         if length(toks)==0
    %             continue
    %         end
    %         drs{end+1}=dr(i1).name;
    %     end
    %%%%------------modified by jing
    dr=dir(sprintf('%s\\%s*.daq',Dir,drspec));
    drs={};
    for i1=1:length(dr)
        drs{end+1}=dr(i1).name;
    end
    %%%%------------end of modification
    save working_file_list drs Dir
end
dr=dir('.\data');
if length(dr)==0
    !mkdir data
end
dtyp=get_signal_start_times;
for i=1:length(dtyp)
    disp(sprintf('%d %s',i,dtyp{i}));
end
it=input_with_default('enter number of band to get',1);
seltype=dtyp{it};
seltype_file=seltype;ix=find(seltype_file==' ');
seltype_file(ix)='_';
SR=40323.58065;
switch seltype
    case 'udel lowband'
        S=load('hfx_signals_low_rcv');
        sigs={S.Ss{1},S.Ss{2},S.Ss{3},S.Ss{4},S.Ss{5},S.Ss{6},S.Ss{7}};
        signames={'qCW1','qCW2','qCW3','40msec','80msec','160msec','320msec'};
        sigoffset=[0,cumsum(sum(round([[S.T{1}(2:end)];[S.Delay{1}(1:end-1)]]*SR)))];
        sigtosigoffset=round(sum(sum([S.T{1};S.Delay{1}]*SR))+.5*SR);
    case 'udel midband'
        S=load('hfx_signals_mid_rcv');
        sigs={S.Ss{1},S.Ss{2},S.Ss{3},S.Ss{4},S.Ss{5},S.Ss{6},S.Ss{7}};
        signames={'qCW1','qCW2','qCW3','40msec','80msec','160msec','320msec'};
        sigoffset=[0,cumsum(sum(round([[S.T{1}(2:end)];[S.Delay{1}(1:end-1)]]*SR)))];
        sigtosigoffset=sum(sum([S.T{1};S.Delay{1}]*SR))+round(.5*SR);
    case 'udel highband'
        S=load('hfx_signals_high_rcv');
        sigs={S.Ss{1},S.Ss{2},S.Ss{3},S.Ss{4},S.Ss{5},S.Ss{6},S.Ss{7}};
        signames={'qCW1','qCW2','qCW3','40msec','80msec','160msec','320msec'};
        sigoffset=[0,cumsum(sum(round([[S.T{1}(2:end)];[S.Delay{1}(1:end-1)]]*SR)))];
        sigtosigoffset=sum(sum([S.T{1};S.Delay{1}]*SR))+round(.5*SR);
    otherwise
        error(sprintf('invalid signal type %s',seltype));
end
for i=1:length(signames)
    disp(sprintf('%d %s',i,signames{i}));
end
isig=input_with_default('enter signal type to get',7);
dirspec=Dir;

[b,a] = butter(8,1000/SR*2);
while 1
    drtext=cell2mat(drs');
    drtext=[reshape(sprintf('% 4d ',[1:length(drs)]),5,length(drs))',drtext];
    dlen=ceil(size(drtext,1)/4)*4;
    drtext(dlen,1)=' ';
    drtext=reshape(drtext',size(drtext,2)*4,size(drtext,1)/4)';
    disp(drtext);
    idir=sprintf('%s\\',dirspec);
    i1=input_with_default('enter file number from above list (0 to exit) ',1);
    if i1==0
        break
    end
    disp(sprintf('processing %s',drs{i1}));
    try
        warning off
        tic
        [d,sampnums,SR,st,et]=get_raw_daq_data(idir,drs{i1},[],1,0,240);
%         daqread([dat_pat_dir,dat_file_name(1:15),'CH',num2str(1),'.dat'],'info')
        %%%%%%%%%%%save into .dat format -- by Jingluo %%%%%%%%%%%%%%%%%
        dat_pat_dir=['E:\rawdata\Deploy2\'];
        dat_file_name=drs{i1};
        dat_dmax=max(abs(d));
        fid=fopen([dat_pat_dir,dat_file_name(1:15),'CH',num2str(1),'.dat'],'w');
        fwrite(fid,d/dat_dmax*2^15,'int16');
        fclose(fid);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%end %%%%%%%%%%%%%%%%%%%%%%%%%%
        
        toc
        warning on
    catch
        disp(sprintf('error - file could not be read'));
        continue
    end
    Data={};
    c1=fftfilt(flipud(sigs{isig}),d);
    c=abs(c1);
    c=filter(b,a,c);
    [cmax,id1]=max(c);
    mm=median(c)/cmax;
    zoom_plot(c(1:10:end));
    fig=gcf;
    title(sprintf('spread, mm=%g (smaller means more likely that signals are present)',mm));
    pts=get_points(0,sprintf('Click on 2 opposite corners of a box that encloses peaks then hit enter when done.\n(to reject, just hit return)'));
    if size(pts,1)<2
        continue
    end
    pts=sortrows(pts(1:2,:));
    pts(:,1)=max(pts(:,1),1);
    pts(:,1)=min(length(c)/10-1,pts(:,1));
    ix1=[10*round(pts(1,1)):10*round(pts(2,1))];
    mn=min(pts(:,2));
    [maxs,ixs]=top_n_peaks(c(ix1),9,3000,mn/cmax);
    ix=find(maxs>.25*max(maxs));
    ixs=ixs(ix);
    pts=ixs+ix1(1)-1;
    disp(sprintf('%d peaks found',length(pts)));
    if input_with_default('save data? ',1)
        disp('saving data')
        ix1=pts(1)-length(sigs{isig})-2000;
        ix1=max(ix1,1);
        ix2=pts(end)+length(sigs{isig})+2000;
        ix2=min(ix2,length(c));
        [d,sampnums,SR,st,et]=get_raw_daq_data(idir,drs{i1},[],1:8,(ix1-1)/SR,(ix2-1)/SR);
        Ns=nearest_small_factor(size(sigs{isig},1));
        fs=flipud(sigs{isig});
        fs(Ns)=0;
        c=fftfilt(fs,d);
        Nc=nearest_small_factor(size(c,1));
        c1=c(:,1);
        c1(Nc)=0;
        c1=abs(hilbert(c1));
        pts=pts-ix1+1;
        clear H
        for i=1:length(pts)
            ix1=pts(i)-5000;
            ix1=max(ix1,1);
            ix2=pts(i)+5000;
            ix2=min(ix2,length(c));
            [m,mix]=max(c1(ix1:ix2)); %find peak
            ix2=mix+ix1-1+4000;
            ix1=mix+ix1-1-1999;
            ix1=max(ix1,1);
            ix2=min(ix2,length(c));
            h=zeros(10000,size(c,2));
            h(1:ix2-ix1+1,:)=c(ix1:ix2,:);
            H(:,:,i)=h;
        end
        try
            Hmax=max(abs(flatten(H)));
            H=int16(round(H/Hmax*32767));
            save(sprintf('data\\%s_band_%d_sig_%d',drs{i1}(1:end-4),it,isig),'SR','H','Hmax','pts','isig');
        catch
            disp(sprintf('error in saving data for file %s',drs{i1}))
        end
    end
    try
        close(fig);
    catch
    end
end