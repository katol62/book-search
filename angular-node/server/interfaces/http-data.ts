import {IUser} from '../models/User';
import {ICompany, ICompanyExtended} from '../models/Company';
import {ITerminal} from '../models/Terminal';

export interface IPaging {
  offset: number;
  limit: number;
}

export interface IBaseRequest {
  id?: number;
  paging?: IPaging;
  filter?: any;
}

export interface IBaseResponse {
  error?: Error;
  message?: string;
  success: boolean;
  data?: any;
}

export interface IAuthRequest extends IBaseRequest{
  email?: string;
  password?: string;
  softcode?: string;
  type?: 'super' | 'admin' | 'cashier' | 'customer' | 'partner';
}

export interface IAuthResponse extends IBaseResponse{
  token?: string;
  user?: IUser;
}

export interface ICompaniesResponse extends IBaseResponse{
  companies?: ICompany[];
  user?: IUser;
}

export interface ICompanyResponse extends IBaseResponse{
  company?: ICompany;
  user?: IUser;
}

export interface ITerminalResponse extends IBaseResponse{
  company?: ICompanyExtended;
  terminal?: ITerminal;
  user?: IUser;
}

export interface ITerminalUpdateRequest extends IBaseRequest{
  terminal?: ITerminal;
}

export interface ITerminalUpdateResponse extends IBaseResponse{
  terminal?: ITerminal;
  user?: IUser;
}

export interface ICompanyUpdateRequest extends IBaseRequest{
  company?: ICompany;
}

export interface ICompanyUpdateResponse extends IBaseResponse{
  id?: number;
}

export interface IAdminsResponse extends IBaseResponse{
  admins?: IUser[];
  user?: IUser;
}

export interface IAdminResponse extends IBaseResponse{
  admin?: IUser;
  user?: IUser;
}

export interface IAdminUpdateRequest extends IBaseRequest{
  admin?: IUser;
}

export interface IAdminUpdateResponse extends IBaseResponse{
  id?: number;
}

export interface ILocationResponse extends IBaseResponse{
  type: 'country' | 'foc' | 'region';
  items?: any[];
}
