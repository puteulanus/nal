var webAuth = new auth0.WebAuth({
    domain: '',
    clientID: '',
    responseType: 'token id_token',
    scope: 'openid',
    redirectUri: window.location.href
});