% Parameters
rojo = 16711680;  % clase nemátodo en movimmiento
verde = 65280;    % clase nemátodo fijo
azul = 255;       % clase ruido (azul)
blanco = 16777215;% clase fondo
negro = 0;        % clase ocultamiento
complementario = 16777216;
radioDilatacion = 40; % parámetro para dilatar trayectorias

%**************************************************************************
% Atributos preprocesamiento
%**************************************************************************
height = 1944;
width = 1944;
umbralBlack = 33;
nivelmediominimo = 45; %Eliminar imágenes oscuras por problemas de captura

%**************************************************************************
% Atributos procesamiento
%**************************************************************************
% Perimetro mínimo de una trayectoria
perimeter_min = 30; %35; //45; Asignar el perimetro mínimo de un Celegans
perimeter_max = 1000;
area_min_inROI = 20; % Considerando 1 C. elegans de tamaño mínimo 20;
area_max_inROI = 240; % Considerando 2 C. Elegans de tamaño máximo 120
% parametros de filtro de color
oscuridad_maxima = 20; % oscuridad_maxima=14; % Filtro por oscuridad de elegans
oscuridad_media_maxima = 27; %20;
% incSize: incremento de la subimagen1 para registrar
incSize = 76;
distMaximaEntreCentroides = 40; % Distancia maxima entre imagenes para considerar que son el mismo c.elegans

% Experiment folder selection
path = 'C:\lifespan\Lifespan18';
% path = uigetdir(path,'Select the experiment folder');
path = strcat(path,'\');
[dias, cond, placas] = read_folder_extructure(path);

javaaddpath('JavaLibrary1.jar'); % incluye opencv-330.jar, ij-1.52p.jar, AnalyzeSkeleton_-3.3.0.jar, Skeletonize3D_-2.1.1.jar
javalibs.LoadOpenCV.loadOpenCV
poligono_interes = javaObject('javalibs.PoligonoInteres');
ImageConverter = javaObject('javalibs.ImageConverter');
imBW_Mat = javaObject('org.opencv.core.Mat');

for dia=1:size(dias,1)
    dia_str=strcat('dia_',num2str(dias(dia)));
    path_dia = strcat(strcat(path,dia_str),'\');
    
    for c=1:size(cond,1)
        cond_str = strcat('cond_',cond(c));
        path_dia_cond = strcat(strcat(path_dia,cond_str),'\'); 
        
        for placa=1:size(placas,1)
            placa_str = strcat('placa_',num2str(placas(placa)));
            path_dia_cond_placa = strcat(strcat(path_dia_cond,placa_str),'\');
            
            ar_imgs=ls(path_dia_cond_placa);
            imgs = [];
            for i=1:size(ar_imgs,1)
                if contains(ar_imgs(i,:),'.cmpr')
                    imgs = [imgs; ar_imgs(i,:)];
                end
            end
            nTotalImagenes = size(imgs,1);
            
            % *************************************************************
            % Centre zone detection (at first image)
            % *************************************************************
            filename = strcat(path_dia_cond_placa, imgs(1,:));
            circuloI  = read_circulo(filename);
            %img = read_img(filename, width, height);
            %imshow(img)
            
            peak = getHistogramPeak(circuloI);
            error_umbral = (48 - peak);
            
            if (poligono_interes.isEmpty())
                circuloImBW = uint8(zeros(size(circuloI)));
                % Negative segmented image
                for j=1:size(circuloI)
                    if (circuloI(j) >= (umbralBlack - error_umbral))
                        circuloImBW(j) = 255;
                    end
                end
                I = descomprimirGray(circuloImBW, width, height);  
                %RGB = cat(3, I, I, I);
                
                imBW_BufferedImage = im2java2d(I);
                %imBW_BufferedImage = im2java2d(RGB);
                
                %matImg = java2d2im(imBW_BufferedImage,0);
                %matImg = java2d2im(imBW_BufferedImage,1);
                
                imBW_Mat = ImageConverter.Set_null(imBW_Mat);
                imBW_Mat = ImageConverter.toMat(imBW_BufferedImage, imBW_Mat);
                poligono_interes.CalcularFrom(imBW_Mat);
            end
            
            % *************************************************************
            % Imgs stack segmentation
            % *************************************************************
            vectorI = uint8(zeros(size(imgs,1),size(circuloI,1)));
            vectorIb = logical(zeros(size(imgs,1),size(circuloI,1)));            
            for i=1:nTotalImagenes
                filename = strcat(path_dia_cond_placa, imgs(i,:));
                circuloI  = read_circulo(filename);
                for j=1:size(circuloI)
                    vectorI(i,j) = circuloI(j);
                    vectorIb(i,j) = circuloI(j) < (umbralBlack - error_umbral);
                end
            end
            
            % *************************************************************
            % Pixel classification
            % *************************************************************
            imagePixels = uint8(zeros(height,width,3));
            r=height/2;  %972;
            y0=height/2; %972;
            k2=1;
            x0=width/2;
            r2=r*r;
            t_image = 1;
            NUM = y0-r;

            if(NUM<0)
                NUM=0;
            end

            i1 = NUM*width;
            if (i1==0)
                i1=1;
            end

            pixel = javaObject('java.awt.Point');
            
            for j=1:1:height
                
                row = j;
                pixel.x = j;
                
                xs=floor(x0-abs(sqrt(r2-(r-j)^2)));
                cx=floor(abs(sqrt(r2 - (r-j)^2)));
                NUM=j*width;
                N1=NUM+width;
                XN=NUM+xs;
                Xc=XN+2*cx;

                i1 = XN -1;
                for i=i1:i1+Xc-XN

                    col = i1 + i - NUM;
                    pixel.y = col;
                    
                    num_blacks = 0;
                    num_whites = 0;
                    valAnt = vectorIb(1,t_image);
                    maximoVal = 0;
                    minimoVal = 255;
                    seriesBlacks = [];
                    seriesWhites = [];
                    longitudMaxBlacks = 0;
                    longitudMaxWhites = 0;
                    serie = 0;

                    for ii = 1:nTotalImagenes

                        % Calculo de longitudes de las series de blancos y negros
                        if (vectorIb(ii,t_image) ~= valAnt)
                            if (valAnt)
                                seriesBlacks = [seriesBlacks, serie];
                                if (serie > longitudMaxBlacks)
                                    longitudMaxBlacks = serie;
                                end
                            else
                                seriesWhites = [seriesWhites, serie];
                                if (serie > longitudMaxWhites)
                                    longitudMaxWhites = serie;
                                end
                            end
                            serie = 1;
                            valAnt = vectorIb(ii,t_image);
                        else
                            serie = serie+1;
                        end

                        if (vectorI(ii,t_image) > maximoVal)
                            maximoVal = vectorI(ii,t_image);
                        end
                        if (vectorI(ii,t_image) < minimoVal)
                            minimoVal = vectorI(ii,t_image);
                        end
                        if vectorIb(ii,t_image)
                            num_blacks = num_blacks+1;
                        else
                            num_whites = num_whites+1;
                        end
                    end

                    if (valAnt) % Insertar la ultima serie
                        seriesBlacks = [seriesBlacks, serie];
                        if (serie > longitudMaxBlacks)
                            longitudMaxBlacks = serie;
                        end
                    else
                        seriesWhites = [seriesWhites, serie];
                        if (serie > longitudMaxWhites)
                            longitudMaxWhites = serie;
                        end
                    end

                    rangoDinamico = maximoVal - minimoVal;
                    chi = size(seriesBlacks,2) + size(seriesWhites,2) - 1;

                    %//System.out.printf("num_blacks:  %d; ",num_blacks);
                    %//System.out.printf("num_whites: %d\n",num_whites);

                    if (num_blacks == 0) %// clase fondo (blanco)
                        imagePixels(row, col, :) = [255, 255, 255];
                        %//System.out.printf("blanco: %d\n",targetPixels[i1+i]);
                    elseif (num_blacks == nTotalImagenes)

                        if (poligono_interes.pixelIn(pixel))
                            imagePixels(row, col, :) = [0, 255, 0];
                            %//System.out.printf("verde: %d\n",targetPixels[i1+i]);
                        else %// zona oculta de paredes 
                            if (rangoDinamico < 10) %// clase paredes
                                imagePixels(row, col, :) = [0, 0, 0];
                                %//System.out.printf("negro: %d\n",targetPixels[i1+i]);
                            else %// clase ruido
                                imagePixels(row, col, :) = [0, 0, 255];
                                %//System.out.printf("azul: %d\n",targetPixels[i1+i]);
                            end
                        end
                    elseif ((chi < 3) && (longitudMaxBlacks >= 3) && (longitudMaxWhites > 5) && (rangoDinamico > 14))
                        %// clase gusano en movimiento (rojo)
                        imagePixels(row, col, :) = [255, 0, 0];

                    else %// clase ruido
                        imagePixels(row, col, :) = [0, 0, 255];
                        %//System.out.printf("azul: %d\n",targetPixels[i1+i]);
                    end

                    t_image = t_image+1;

                end

                i1=i1+Xc-XN;
                k2=k2+Xc-XN;
                %imagen_rectangular(i1:N1-i1) = negro;
                i1 = N1 - 1;
           end
           figure; imshow(imagePixels);
        end
    end
end