export const apiRequest = async (url, method, body) => {
    try {
        const res = await fetch(url, {
            method,
            headers: {
                Accept: "application/json",
                "Content-Type": "application/json"
            },
            body: body ? JSON.stringify(body) : undefined
        });
        const json = await res.json();
        return json;
    } catch (e) {
        return(e);
    }
};

