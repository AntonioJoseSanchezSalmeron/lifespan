clear
clc

Exp18=1;
% Exp14V1=1;
% Exp14V2=2;
% Exp15V1=3;
% Exp15V2=4;
% Exp13V1=5;
% Exp13V2=6;
% Exp18=7;
Experiments = {
    '\\192.168.1.181\Compartida\Lifespan18\'
%     '/media/joan/08E651C0E651AF26/IMAGENS/Lifespan14 V1 PROC_7/'
%     '/media/joan/08E651C0E651AF26/IMAGENS/Lifespan14 V2 PROC_7/'
%     '/media/joan/08E651C0E651AF26/IMAGENS/Lifespan15 V1 PROC_7/'
%     '/media/joan/08E651C0E651AF26/IMAGENS/Lifespan15 V2 PROC_7/'
%     '/media/joan/08E651C0E651AF26/IMAGENS/Lifespan13 V1 PROC_7/'
%     '/media/PC_RETS_NEURONALS/Lifespan13 V2/'
%     '/media/PC_RETS_NEURONALS/Lifespan18/'
    } ;
experiments= length(Experiments);
Exp=Exp18;

dies={
    [1 4 5 6 7 8 11 12 13 14 15 18 19 21 22 25 ]
%     [1 4 5 6 7 8 11 12 13 14 15 18 19 21 22 25 26 27 28 29 ]
%     [1 4 5 6 7 8 11 12 13 14 15 18 19 21 22 25 26 27 28 29 ]
%     [1 4 5 6 7 8 11 12 13 14 15 18 19 20 21 22 ]
%     [1 4 5 6 7 8 11 12 13 14 15 18 19 20 21 22 ]    
%     [1 4 5 6 7 8 11 12 13 14 15 18 19 21 22 25 26 27 28 29 ]
%     [1 4 5 6 7 8 11 12 13 14 15 18 19 21 22 25 26 27 28 29 ]   
%     [1 4 5 6 7 8 11 12 13 14 15 18 19 20 21 22 25 ]
    };

condicions= {
    ['A' 'B' 'C' 'D']
%     ['A' 'B']
%     ['A' 'B']
%     ['A' 'B']
%     ['A' 'B']
%     ['A' 'B']
%     ['A' 'B']
%     ['A' 'B' 'C' 'D']
    };
PLAQUES={
    [1 2 3 4 ]
%     [1 2 3 4 5 6 7 8 9 10]
%     [1 2 3 4 5 6 7 8 9 10]
%     [1 2 3 4 5 6 7 8 9 10]
%     [1 2 3 4 5 6 7 8 9 10]
%     [1 2 3 4 5 6 7 8 9 10]
%     [1 2 3 4 5 6 7 8 9 10]
%     [1 2 3 4 ]
    };
maxDay=max(max(cell2mat(dies)));
maxPlates=max(max(cell2mat(PLAQUES)))*max(strlength(condicions(:)));
manuals=zeros(maxDay,maxPlates,experiments);
%manual =zeros(maxDay,maxPlates,experiments);
auto=zeros(maxDay,maxPlates,experiments);
% xCond=[]; 
% for i=1:length(plaques):length(condicions)*length(plaques)
%     xCond=[xCond; i:(i+length(plaques)-1)];
% end

for iExp = 1:experiments
    ExpCondicions = condicions{iExp};
    for cond = 1:length(ExpCondicions)
        for dia=dies{iExp}
            vius=0;
            plaques=PLAQUES{iExp};
            for placa=plaques

                % %%%%%%%% AUTOMATICS %%%%%%%%%%%%%
                vius1=0;
                filename1 = [ Experiments{iExp} 'dia_' int2str(dia) '\cond_' ExpCondicions(cond) '\placa_' int2str(placa) '\conteoAutomatic.xml'];
                if exist(filename1,'file') ==2 
                    % File exists.
                    archiu1=xmlread(filename1);
                    if ~isempty(archiu1.getElementsByTagName( 'CE_Automatic' ).item( 0 ))
                        if ~isempty(archiu1.getElementsByTagName( 'CE_Automatic' ).item( 0 ).getFirstChild)
                            coordenades1 = archiu1.getElementsByTagName( 'CE_Automatic' ).item( 0 ).getFirstChild.getNodeValue( );
                            elements1 = str2num(split(coordenades1,' '));
                            vius1=length(elements1)/2;
                        else
                            vius1=0;
                        end
                    end
                else
                     % File does not exist.
                end

                % %%%%%%% MANUALS %%%%%%%%%%%%%%%%
                vius2=0;
                filename2=[Experiments{iExp} 'dia_' int2str(dia) '\cond_' ExpCondicions(cond) '\placa_' int2str(placa) '\conteoManual.xml'];
                if exist(filename2, 'file') == 2
                    % File exists.
                    archiu2=xmlread(filename2);
                    if ~isempty(archiu2.getElementsByTagName( 'CE_Manuals' ).item( 0 ))
                        if ~isempty(archiu2.getElementsByTagName( 'CE_Manuals' ).item( 0 ).getFirstChild)
                            coordenades2 = archiu2.getElementsByTagName( 'CE_Manuals' ).item( 0 ).getFirstChild.getNodeValue( );
                            elements2 = str2num(split(coordenades2,' '));
                            vius2=length(elements2)/2;
                        else
                            vius2=0;
                        end
                    end
                else
                     % File does not exist.
                end

                manuals(dia,cond*length(plaques)-(length(plaques))+placa, iExp)=vius2;
                auto(dia,cond*length(plaques)-(length(plaques))+placa, iExp)=vius1;
            end

        end
    end
end

%% Auto
for iExp=1:experiments
    ExpCondicions = condicions{iExp};
    plaques=PLAQUES{iExp};
    for iCP=1:length(ExpCondicions)*length(plaques)
        DIES=dies{iExp};
        auto(1,iCP,iExp)=manuals(1,iCP,iExp);
        for k=2:DIES(length(DIES))
            if isempty(find(DIES==k, 1))
                auto(k,iCP,iExp)=auto(k-1,iCP,iExp);
            end
        end
    end
end

%% Filtrat manual
%manuals(manuals>13)=13;
manual = manuals;
for iExp=1:experiments
    ExpCondicions = condicions{iExp};
    plaques=PLAQUES{iExp};
    for iCP=1:length(ExpCondicions)*length(plaques)
        k=1;
        DIES=dies{iExp};
        while k<=DIES(length(DIES))
            vi = max(manual(k:DIES(length(DIES)),iCP, iExp));
            K = find(manual(:,iCP,iExp)==vi);
            ki = max(K); 
            manual(k:ki,iCP,iExp)=vi;
            k=ki+1;
        end
    end
end

%% POST PROCESS
%dies=60;
post=auto;
for iExp=1:experiments
    
    ExpCondicions = condicions{iExp};
    plaques=PLAQUES{iExp};
    for i=1:length(ExpCondicions)*length(plaques)
        idx=find(post(:,i,iExp)>manual(1,i,iExp));
        post(idx,i,iExp)=manual(1,i,iExp);
    end
    
    % INICI POST PROCESS
    for i=1:length(ExpCondicions)*length(plaques)
        DIES=dies{iExp};
        for idia=2:DIES(length(DIES))    
            if isempty(find(DIES==idia))
                val = max(DIES(find(DIES<idia)));
                post(idia,i,iExp)= post(val,i,iExp);
            end       
        end
    end
    DIES=dies{iExp};
    for dia= 2:DIES(length(DIES)) %dies(2:length(dies)) 
        for placa=1:length(ExpCondicions)*length(plaques)
            if dia<=14
                X = post(dia,placa,iExp);
                i=1;
                while (dia-i)>0 &&  X>post(dia-i,placa,iExp) 
                    post(dia-i,placa,iExp) = X;
                    i=i+1;
                end
                idia=dia;
            else  
                X = post(dia,placa,iExp);
                if X>post(dia-1,placa,iExp)
                    post(dia,placa,iExp) = post(dia-1,placa,iExp);
                end
            end
        end
    end % FI POST-PROCESS
end

%% Analisis en desviacions dels errors per CONDICIO
% Analisis Desviacio Tipica i Mija per dia
% Censura
COND={
    [1  2  3  4]
    [5  6  7  8]
    [9 10 11 12]
    [13 14 15 16]};
mija=[]; mijaA=[]; mijaP=[];
for iCond=1:size(COND,1) %experiments
    % De la Poblacio                                 
    [mija(:,iCond),  sigma(:,iCond)]               = desviacio_Estandart  (manual(:,COND{iCond},iExp));
    % Dels Errors
    [mijaA(:,iCond), sigmaA(:,iCond),textA(:,iCond)] = desviacio_Error_Total(auto(:,COND{iCond},iExp), manual(:,COND{iCond},iExp));
    [mijaP(:,iCond), sigmaP(:,iCond),textP(:,iCond)] = desviacio_Error_Total(post(:,COND{iCond},iExp), manual(:,COND{iCond},iExp));
end

% Analisis Desviacio i Mija Total
error_Auto=[]; error_Post=[]; mijaSigmaAuto=[]; mijaSigmaPost=[];
for iCond=1:size(COND,1) %experiments
    DIES=dies{iExp};
    restriccionsDies=DIES(2:length(DIES));
    error_Auto(:,iCond)   = sum(abs(mijaA(restriccionsDies,iCond))  *100  )/length(restriccionsDies);
    error_Post(:,iCond)   = sum(abs(mijaP(restriccionsDies,iCond))  *100  )/length(restriccionsDies);
    
    mijaSigmaAuto(:,iCond)   = sqrt( (   sum( sigmaA(restriccionsDies,iCond).^2   )/length(restriccionsDies))) *100;
    mijaSigmaPost(:,iCond)   = sqrt( (   sum((sigmaP(restriccionsDies,iCond).^2)  )/length(restriccionsDies))) *100;
end


for iCond=1:size(COND,1)
    super_Auto(:,iCond) = sum(auto(:,COND{iCond},iExp),2) ./ sum(manual(1,COND{iCond},iExp),2);
    super_Post(:,iCond) = sum(post(:,COND{iCond},iExp),2) ./ sum(manual(1,COND{iCond},iExp),2);
end


for iCond=1:size(COND,1)
    figure
    hold on
    %errorbar(mija(:,iExp),sigma(:,iExp), 'k')
    plot(mija(:,iCond), 'k')
    %errorbar(mija(:,iExp)+mijaP(:,iExp), sigmaP(:,iExp), 'b')
    plot(super_Auto(:,iCond), 'b')
    plot(super_Post(:,iCond), 'r')
    % errorbar(mija(:,iExp)+mijaP(:,iExp), sigmaP(:,iExp), 'r')
    %errorbar(mija(:,iExp)+mijaA(:,iExp), sigmaA(:,iExp), 'r')
    %errorbar(mija(:,iExp)+mijaP(:,iExp), sigmaB(:,iExp), 'r')
    set(gca,'fontsize',12)
    
    condition=condicions{iExp};
    title(['Condition ', condition(iCond)])
    legend(['Manual (population: ', num2str(sum(manual(1,COND{iCond,:},iExp),2)), ')'], ...
        ['AutoError=' num2str(error_Auto(iCond)) '%'], ...
        ['errorPost=' num2str(error_Post(iCond)) '%'])
    xlabel('time (days)') % x-axis label
    ylabel('Survival (%)') % y-axis label
    hold off
end
