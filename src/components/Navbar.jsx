import React from 'react'
import { NavLink } from 'react-router-dom'
import { useSelector } from 'react-redux'

const Navbar = () => {
    const state = useSelector(state => state.handleCart)
    
    // FORCE CACHE BUST - Unique content to force new hash
    const buildTime = process.env.REACT_APP_BUILD_TIME || new Date().toISOString()
    const commitHash = process.env.REACT_APP_COMMIT_HASH || Math.random().toString(36)
    const uniqueId = `CACHE_BUST_${Date.now()}_${Math.random()}`
    console.log(`🚀 EcomerceWebsite JSTest - Build: ${buildTime}, Commit: ${commitHash}, ID: ${uniqueId}`)
    
    return (
        <nav className="navbar navbar-expand-lg navbar-light bg-dark py-3 sticky-top">
            <div className="container">
                <NavLink className="navbar-brand fw-bold fs-4 px-2 text-white" to="/"> EcomerceWebsite JSTest </NavLink>
                <button className="navbar-toggler mx-2" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                    <span className="navbar-toggler-icon"></span>
                </button>

                <div className="collapse navbar-collapse" id="navbarSupportedContent">
                    <ul className="navbar-nav m-auto my-2 text-center">
                        <li className="nav-item">
                            <NavLink className="nav-link text-white" to="/">🏠 Homes</NavLink>
                        </li>
                        <li className="nav-item">
                            <NavLink className="nav-link text-white" to="/product">📦 Products Test</NavLink>
                        </li>
                        <li className="nav-item">
                            <NavLink className="nav-link text-white" to="/about">ℹ️ About This project</NavLink>
                        </li>
                        <li className="nav-item">
                            <NavLink className="nav-link text-white" to="/contact">📞 Contact us now </NavLink>
                        </li>
                    </ul>
                    <div className="buttons text-center">
                        <NavLink to="/login" className="btn btn-outline-dark m-2"><i className="fa fa-sign-in-alt mr-1"></i> Login</NavLink>
                        <NavLink to="/register" className="btn btn-outline-dark m-2"><i className="fa fa-user-plus mr-1"></i> Register</NavLink>
                        <NavLink to="/cart" className="btn btn-outline-dark m-2"><i className="fa fa-cart-shopping mr-1"></i> Cart ({state.length}) </NavLink>
                    </div>
                </div>


            </div>
        </nav>
    )
}

export default Navbar