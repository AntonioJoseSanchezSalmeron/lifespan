% Experiment folder selection
path = 'C:\lifespan\Lifespan18';
% path = uigetdir(path,'Select the experiment folder');
path = strcat(path,'\');
[dias, cond, placas] = read_folder_extructure(path);

% Load lib
javaaddpath('JavaLibrary1.jar'); % incluye opencv-330.jar, ij-1.52p.jar, AnalyzeSkeleton_-3.3.0.jar, Skeletonize3D_-2.1.1.jar
javalibs.LoadOpenCV.loadOpenCV
OpenCV_Engine = javaObject('javalibs.OpenCV_Engine');

height = 1944;
width = 1944;

for dia=1:size(dias,1)
    dia_str=strcat('dia_',num2str(dias(dia)));
    path_dia = strcat(strcat(path,dia_str),'\');
    
    esPrimerDia = (dia == 1);
    if (~esPrimerDia)
        dia_ant_str=strcat('dia_',num2str(dias(dia-1)));
        path_dia_ant = strcat(strcat(path,dia_ant_str),'\');    
    end
    
    for c=1:size(cond,1)
        cond_str = strcat('cond_',cond(c));
        path_dia_cond = strcat(strcat(path_dia,cond_str),'\'); 

        if (~esPrimerDia)
            path_dia_ant_cond = strcat(strcat(path_dia_ant,cond_str),'\');    
        end
    
        for placa=1:size(placas,1)
            placa_str = strcat('placa_',num2str(placas(placa)));
            path_dia_cond_placa = strcat(strcat(path_dia_cond,placa_str),'\');

            if (~esPrimerDia)
                path_dia_ant_cond_placa = strcat(strcat(path_dia_ant_cond,placa_str),'\');
            else
                path_dia_ant_cond_placa = path_dia_cond_placa;
            end
        
            ar_imgs=ls(path_dia_cond_placa);
            imgs = [];
            for i=1:size(ar_imgs,1)
                if contains(ar_imgs(i,:),'.cmpr')
                    imgs = [imgs; ar_imgs(i,:)];
                end
            end
            
            % Show first image
            %filename = strcat(path_dia_cond_placa, imgs(1,:));
            %img = read_img(filename, width, height);
            %imshow(img);
            
            % First pipeline: sequence processing
            OpenCV_Engine.nTotalImagenes = size(imgs,1);
            sub = split(imgs(1,:),"_");
            camara = strcat(sub{1},"_");
            OpenCV_Engine.rutaRaiz = path_dia_cond_placa;
            
            OpenCV_Engine.segmentar_imagenes(camara);
            BufferedImage = OpenCV_Engine.clasificarPixeles();
            OpenCV_Engine.filtrar(BufferedImage);
            
            % Second pipeline: image processing
            if (~esPrimerDia)
                OpenCV_Engine.rutaRaizAnt = path_dia_ant_cond_placa;
                OpenCV_Engine.procesar_fusionar(camara, esPrimerDia);
            end
        end
    end
end
