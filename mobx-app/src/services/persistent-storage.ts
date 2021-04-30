
export default class PesistentStorage {

    getItem(key: string): any {
        const obj = sessionStorage.getItem(key);
        return obj ? JSON.parse(obj) : null;
    }

    setItem(key: string, data: any) {
        sessionStorage.setItem(key, JSON.stringify(data))
    }

    clear() {
        sessionStorage.clear();
    }

}
