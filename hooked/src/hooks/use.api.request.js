import { useEffect, useState } from 'react';

export const useApiRequest = (url, options) => {
    const [response, setResponse] = useState(null);
    const [error, setError] = useState(null);
    const [isLoading, setIsLoading] = useState(false);

    useEffect(() => {
        const fetchData = async () => {
            setIsLoading(true);
            try {
                const res = await fetch(url, options);
                const json = await res.json();
                setResponse(json);
                setIsLoading(false);
            } catch (e) {
                setError(e);
            }
        };
        fetchData();
    }, []);
    return { response, error, isLoading };
};

// export default useApiRequest;
