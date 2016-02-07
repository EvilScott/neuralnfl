NeuralNFL = {
    init: function() {
        $('form#inputs').submit(function(e) {
            e.preventDefault();

            if ($('form#inputs').serializeArray().some(function(field) { return field.value === '' })) {
                return NeuralNFL.showError();
            }

            $.ajax({
                url: '/',
                method: 'post',
                data: NeuralNFL.getData(),
                dataType: 'json',
                error: NeuralNFL.showError,
                success: function(res) {
                    var $results = $('#results');
                    $results.empty();
                    res.forEach(function(play) {
                        var type = play[0];
                        var percent = play[1];
                        if (parseFloat(play[1]) > 0.0) {
                            $results.append(
                                '<div class="result">' +
                                '<div class="bar" style="width:' + parseFloat(percent) * 8 + 'px;"></div>' +
                                '<div class="label">' + type + ' : ' + percent + '%</div>' +
                                '</div>'
                            );
                        }
                    });
                    $('html, body').animate({ scrollTop: $('#results').offset().top }, 500);
                }
            });
        });
    },
    getData: function() {
        return $('form#inputs').serializeArray().reduce(function(values, field) {
            values[field.name] = field.value;
            return values;
        }, {})
    },
    showError: function() {
        $('p.error').fadeTo(250, 1).delay(500).fadeTo(250, 0);
    }
};

$(NeuralNFL.init);
