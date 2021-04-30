export interface IUser {
    id?: number;
    name?: string;
    last?: string;
    phone?: string;
    email?: string;
    password?: string;
    parent?: number;
    role?: 'super' | 'admin' | 'cashier' | 'customer' | 'partner';
    publisher?: '0' | '1';
}
