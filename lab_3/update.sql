update color
set
    color_name = '#ff0000'
where color_name = 'Красный'
returning id, color_name;

update color
set
    color_name = '#000000'
where color_name = 'Чёрный'
returning id, color_name;

update color
set
    color_name = '#ffffff'
where color_name = 'Белый'
returning id, color_name;

-- Вернуть обратно

update color
set
    color_name = 'Красный'
where color_name = '#ff0000'
returning id, color_name;

update color
set
    color_name = 'Чёрный'
where color_name = '#000000'
returning id, color_name;

update color
set
    color_name = 'Белый'
where color_name = '#ffffff'
returning id, color_name;