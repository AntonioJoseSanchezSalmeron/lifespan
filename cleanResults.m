% OS detection
currentFolder = pwd;
if ismac
    % Code to run on Mac platform
    disp('It is Mac OS')
elseif isunix
    disp('It is Unix OS')
    path = strcat(currentFolder,'/Lifespan18');
    path = strcat(path,'/');
    slash='/';
elseif ispc
    disp('It is Windows OS')
    path = strcat(currentFolder,'\Lifespan18');
    path = strcat(path,'\');
    slash='\';
else
    disp('Platform not supported')
end

% Experiment folder selection
% currentFolder = pwd;
% path = strcat(currentFolder,'\Lifespan18');
% % path = uigetdir(path,'Select the experiment folder');
% path = strcat(path,'\');
[dias, cond, placas] = read_folder_extructure(path,slash);

height = 1944;
width = 1944;

for dia=1:size(dias,1)
    dia_str=strcat('dia_',num2str(dias(dia)));
    path_dia = strcat(strcat(path,dia_str),slash);
    
    esPrimerDia = (dia == 1);
    if (~esPrimerDia)
        dia_ant_str=strcat('dia_',num2str(dias(dia-1)));
        path_dia_ant = strcat(strcat(path,dia_ant_str),slash);    
    end
    
    for c=1:size(cond,1)
        cond_str = strcat('cond_',cond(c));
        path_dia_cond = strcat(strcat(path_dia,cond_str),slash); 

        if (~esPrimerDia)
            path_dia_ant_cond = strcat(strcat(path_dia_ant,cond_str),slash);    
        end
    
        for placa=1:size(placas,1)
            placa_str = strcat('placa_',num2str(placas(placa)));
            path_dia_cond_placa = strcat(strcat(path_dia_cond,placa_str),slash);

            if (~esPrimerDia)
                path_dia_ant_cond_placa = strcat(strcat(path_dia_ant_cond,placa_str),slash);
            else
                path_dia_ant_cond_placa = path_dia_cond_placa;
            end
        
            ar_imgs=dir(path_dia_cond_placa);
            imgs = [];
            for i=1:size(ar_imgs,1)
                if (contains(ar_imgs(i).name,'.xml') || ...
                    contains(ar_imgs(i).name,'.bin') || ...
                    contains(ar_imgs(i).name,'.txt') || ...
                    contains(ar_imgs(i).name,'.bmp') || ...
                    contains(ar_imgs(i).name,'.jpg'))
                	filename = strcat(path_dia_cond_placa, ar_imgs(i).name);
                	delete(filename)
                end               
            end         
        end
    end
end
