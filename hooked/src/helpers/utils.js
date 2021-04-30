import * as validator from 'validator';

export const apiRequest = async (url, method, body, token = null) => {
    const headers = {
        "Accept": "application/json",
        "Content-Type": "application/json"
    };
    if (token != null) {
        headers['Authorization'] = 'Bearer: ' + token
    }
    const res = await fetch(url, {
        method,
        headers: headers,
        body: body ? JSON.stringify(body) : undefined
    });
    const json = await res.json();
    return json;
};

export const validateLoginForm = (
    email,
    password,
    setError) => {
    // Check for undefined or empty input fields
    if (!email || !password) {
        setError("Please enter a valid email and password.");
        return false;
    }
// Validate email
    if (!validator.isEmail(email)) {
        setError("Please enter a valid email address.");
        return false;
    }
    return true;
};
