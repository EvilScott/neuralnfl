NeuralNFL = {
    init: function() {
        $('form#inputs').submit(function(e) {
            e.preventDefault();

            $.ajax({
                url: '/',
                method: 'post',
                data: $('form#inputs').serializeArray().reduce(function(values, field) {
                    values[field.name] = field.value;
                    return values;
                }, {}),
                error: function() {
                    alert('incomplete form');
                },
                success: function(res) {
                    console.log(res);
                }
            });
        });
    }
};

$(NeuralNFL.init);
