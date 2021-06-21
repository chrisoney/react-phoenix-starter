// constants
const SET_SESSION = "session/SET_SESSION";
const REMOVE_USER = "session/REMOVE_USER";

import { setAuthToken, removeAuthToken, getAuthToken, authFetch } from '../utils/auth';

const setSession = (session) => ({
  type: SET_SESSION,
  payload: session
});

const removeUser = () => ({
  type: REMOVE_USER,
})

export const authenticate = () => async (dispatch) => {
  const response = await authFetch('/api/users/current/', {
    headers: {
      'Content-Type': 'application/json',
      // 'Authorization': `Bearer ${getAuthToken()}`
    }
  });
  const data = await response.json();
  if (data.errors) {
    return;
  }
  if (data.token){
    dispatch(setSession(data))
  }
}
  
export const login = (email, password) => async (dispatch)  => {
  const response = await fetch('/api/sessions/', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      email,
      password
    })
  });
  const data = await response.json();
  if (data.errors) {
      return data;
  }
  setAuthToken(data.token);
  dispatch(setSession(data))
  return {};
}
  
export const logout = () => async (dispatch) => {
  const response = await fetch("/api/sessions/", {
    method: 'DELETE',
    headers: {
      "Content-Type": "application/json",
      'Authorization': `Bearer ${getAuthToken()}`
    }
  });
  
  const data = await response.json();
  removeAuthToken();
  dispatch(removeUser());
};
  
  
export const signUp = (username, email, password) => async (dispatch) => {
  const response = await fetch("/api/users/", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      user: {
        username,
        email,
        password,
      }
    }),
  });
  const data = await response.json();
  console.log(data)
  if (data.errors) {
      return data;
  }
  setAuthToken(data.token);
  dispatch(setSession(data))
  return {};
  }


const initialState = { user: null, authenticated: false };

export default function reducer(state=initialState, action) {
  switch (action.type) {
    case SET_SESSION:
      return {user: action.payload.user, authenticated: true}
    case REMOVE_USER:
      return {user: null, authenticated: false}
    default:
      return state;
  }
}
