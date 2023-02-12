let currentItem = undefined

$(window).ready(function () {
    window.addEventListener('message', function (event) {
        let data = event.data
        if (data.toggle) {
            $("body").fadeIn()
            $('.cat').html(addcat(data.cat))
            $('.itemss').html(additem(data.items))
            addMat(data.items)
        }

        function addcat(cat) {
            let html = '<b>'
            let catData = JSON.parse(cat)

            for (let i = 0; i < catData.length; i++) {
                html += '<button class="incat" style="width:fit-content; margin-right: 10px; height: 40px;" data-thecat="' + catData[i].catid + '">' + catData[i].label + '</button>'
            }
            html += '</b>'
            return html
        }

        function additem(items) {
            let html = ''
            let itemData = JSON.parse(items)

            for (let i = 0; i < itemData.length; i++) {
                html += '<div class="col-2 m-2 item cat-' + itemData[i].catid + '" data-id="' + i + '">'
                html += '<img class="item-img img-' + i + '" src="img/' + itemData[i].name + '.png" alt="" height=128px width=128px>'
                html += '<div class="item-desc desc-' + i + '"><p style="font-size: 20px;"><b>' + itemData[i].label + '</b></p>'
                html += '<button class="wear ' + itemData[i].name + '" data-item="' + itemData[i].name + '" data-itemname="' + itemData[i].label + '"><i class="fa-solid fa-pen-ruler"> craft</i></button></div></div>'
            }
            return html
        }

        function addMat(items) {
            let itemData = JSON.parse(items)

            for (let i = 0; i < itemData.length; i++) {
                $('.'+itemData[i].name).data('material', itemData[i].material)
            }
        }

        $('.item').hover(function () {
            let a = $(this).data('id')
            $('.desc-' + a).css('opacity', 1);
            $('.img-' + a).css('opacity', 0);
        }, function () {
            let a = $(this).data('id')
            $('.desc-' + a).css('opacity', 0);
            $('.img-' + a).css('opacity', 1);
        })

        $('.item').hover(function () {
            let a = $(this).data('id')
            $('.desc-' + a).css('opacity', 1);
            $('.img-' + a).css('opacity', 0);
        }, function () {
            let a = $(this).data('id')
            $('.desc-' + a).css('opacity', 0);
            $('.img-' + a).css('opacity', 1);
        })

        $("[type='number']").keypress(function (evt) {
            evt.preventDefault();
        })

        $('.wear').click(function () {
            let itemname = $(this).data('itemname')
            let mat = $(this).data('material')
            currentItem = $(this).data('item')
            $('.items').css('display', 'none');
            $('.info').css('display', 'block');
            $('.back').css('display', 'block');
            $('.cat').css('display', 'none');
            $('.matlist').html(infoReady(mat));
            $('.infoname').html(itemname);
            $(".info-img").attr("src", "img/" + currentItem + ".png");
        })

        $('.back').click(function () {
            $('.info').css('display', 'none');
            $('.items').css('display', 'block');
            $('.cat').css('display', 'block');
            $('input').val(1);
            $(this).css('display', 'none');
        })

        $('.incat').click(function () {
            let isActive = $(this).hasClass('active');
            let thecat = $(this).data('thecat');
            if (!isActive) {
                $('.active').removeClass('active');
                $(this).addClass('active');
                $('.item').css('display', 'none');
                $('.cat-' + thecat).css('display', 'block');
            } else {
                $(this).removeClass('active');
                $('.item').css('display', 'block');
            }
        })

        function infoReady(mats) {
            let html = ''
            let matData = JSON.parse(mats)
            console.log(matData.length)

            for (let i = 0; i < matData.length; i++) {
                html += '<p><b>' + matData[i].count + 'x </b><span class="infoitem"><img src="img/' + matData[i].name + '.png" alt=""height=42px width=42px>' + matData[i].label + '</span></p>'
            }
            return html
        }
    })
    $('.doit').click(function () {
        var count = $(".craft-count").val();
        $('.info').css('display', 'none');
        $('.items').css('display', 'block');
        $('.cat').css('display', 'block');
        $('.back').css('display', 'none');
        $('input').val(1);
        $("body").fadeOut()
        $.post('https://0crafting0/craft', JSON.stringify({ Item: currentItem, Count: count }));
    })
    document.onkeyup = function (data) {
        if (data.keyCode == 27) {
            $('.info').css('display', 'none');
            $('.items').css('display', 'block');
            $('.cat').css('display', 'block');
            $('.back').css('display', 'none');
            $('input').val(1);
            $("body").fadeOut()
            $.post('https://0crafting0/close', '{}');
        }
    }
})