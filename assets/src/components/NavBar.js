import React from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { NavLink } from 'react-router-dom';
import LogoutButton from './auth/LogoutButton';

const NavBar = () => {
  const authenticated = useSelector(state => state.session.authenticated);
  // const authenticated = true;
  return (
    <nav>
      <ul>
        <li>
          <NavLink to="/" exact={true} activeClassName="active">
            Home
          </NavLink>
        </li>
        {!authenticated ?
          <>
            <li>
              <NavLink to="/login" exact={true} activeClassName="active">
                Login
              </NavLink>
            </li>
            <li>
              <NavLink to="/sign-up" exact={true} activeClassName="active">
                Sign Up
              </NavLink>
            </li>
            <li>
              <NavLink to="/users" exact={true} activeClassName="active">
                Users
              </NavLink>
            </li>
          </> :
          <li>
            <LogoutButton />
          </li>
        }
      </ul>
    </nav>
  );
}

export default NavBar;
