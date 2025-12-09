import React from 'react'
import { NavLink } from 'react-router-dom'
import { useSelector } from 'react-redux'

const Navbar = () => {
    const state = useSelector(state => state.handleCart)
    
    // Automatic cache-busting with comprehensive build info
    const buildTime = process.env.REACT_APP_BUILD_TIME || new Date().toISOString()
    const commitHash = process.env.REACT_APP_COMMIT_HASH || 'dev'
    const buildNumber = process.env.REACT_APP_BUILD_NUMBER || '0'
    const pipelineId = process.env.REACT_APP_PIPELINE_ID || Math.random().toString(36).substr(2, 9)
    
    console.log(`🚀 EcomerceWebsite JSTest - DEPLOYMENT INFO:`)
    console.log(`   Build: ${buildTime} | Commit: ${commitHash}`)
    console.log(`   Build #: ${buildNumber} | Pipeline: ${pipelineId}`)
    console.log(`   Cache-Bust ID: DEPLOY_${Date.now()}`)
    
    return (
        <nav className="navbar navbar-expand-lg navbar-light bg-dark py-3 sticky-top">
            <div className="container">
                <NavLink className="navbar-brand fw-bold fs-4 px-2 text-white" to="/"> Testin CI/CD cache </NavLink>
                <button className="navbar-toggler mx-2" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                    <span className="navbar-toggler-icon"></span>
                </button>

                <div className="collapse navbar-collapse" id="navbarSupportedContent">
                    <ul className="navbar-nav m-auto my-2 text-center">
                        <li className="nav-item">
                            <NavLink className="nav-link text-white" to="/">🏠 Homes</NavLink>
                        </li>
                        <li className="nav-item">
                            <NavLink className="nav-link text-white" to="/product">📦 ProducTest</NavLink>
                        </li>
                        <li className="nav-item">
                            <NavLink className="nav-link text-white" to="/about">ℹ️ About CI?CD</NavLink>
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