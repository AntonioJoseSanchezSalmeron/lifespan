function [dias, cond, placas] = read_folder_extructure(path)
    ar_dias=ls(path);
    dias = [];
    for i=1:size(ar_dias,1)
        if contains(ar_dias(i,:),'dia_')
            subCadenas = strsplit(ar_dias(i,:),'_');
            dias = [dias; str2double(subCadenas{2})];
        end
    end
    dias = sort(dias);

    dia_str=strcat('dia_',num2str(dias(1)));
    path_dia = strcat(strcat(path,dia_str),'\');
    ar_cond=ls(path_dia);
    cond = [];
    for i=1:size(ar_cond,1)
        if contains(ar_cond(i,:),'cond_')
            subCadenas = strsplit(ar_cond(i,:),'_');
            cond = [cond; subCadenas{2}];
        end
    end
    cond = sort(cond);

    cond_str = strcat('cond_',cond(1));
    path_dia_cond = strcat(strcat(path_dia,cond_str),'\');
    ar_placas=ls(path_dia_cond);
    placas = [];
    for i=1:size(ar_placas,1)
        if contains(ar_placas(i,:),'placa_')
            subCadenas = strsplit(ar_placas(i,:),'_');
            placas = [placas; str2double(subCadenas{2})];
        end
    end
    placas = sort(placas);

end