export enum ENavbarType {
  home, companies, admins, cards
}

export interface INavbarItem {
  id: ENavbarType;
  label: string;
  path: string[];
  roles: string[];
}
