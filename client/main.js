const API_URL = `http://${window.location.hostname}:8089/people`;

const findAll = async () => {
    let tbody = document.getElementById('tbody');
    let names = [];

    await fetch(API_URL, {
        method: 'GET',
        headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
        }
    }).then(response => response.json()).then(result => {
        names = [ ...result.data ];
        let content = '';

        names.forEach(itm => content += `<tr>
                                            <td>${itm.name}</td>
                                        </tr>`);

        tbody.innerHTML = content;
    })
    .catch(console.log);
}

(() => {
    findAll();
})()

const guardar = async () => {
    const person = {
        name: document.getElementById('name').value
    }

    await fetch(API_URL, {
        method: 'POST',
        headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
        },
        body: JSON.stringify(person)
    }).then(response => response.json()).then(() => {
        document.getElementById('name').value = '';
        findAll();
    }).catch(console.log);
}
