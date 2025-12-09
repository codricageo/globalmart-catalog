// UniversalCacheBuster.js - Add this to ANY React project
// Import and use in your main App component or Navbar

import { useEffect } from 'react';

export const UniversalCacheBuster = () => {
    useEffect(() => {
        // Universal build information logging
        const buildInfo = {
            buildTime: process.env.REACT_APP_BUILD_TIME || 'dev-mode',
            commitHash: process.env.REACT_APP_COMMIT_HASH || 'local',
            buildNumber: process.env.REACT_APP_BUILD_NUMBER || '0',
            pipelineId: process.env.REACT_APP_PIPELINE_ID || 'manual',
            cacheBust: process.env.REACT_APP_CACHE_BUST || Date.now()
        };
        
        console.log('🚀 UNIVERSAL DEPLOYMENT INFO:');
        console.log(`   Build Time: ${buildInfo.buildTime}`);
        console.log(`   Commit: ${buildInfo.commitHash}`);
        console.log(`   Build #: ${buildInfo.buildNumber}`);
        console.log(`   Pipeline: ${buildInfo.pipelineId}`);
        console.log(`   Cache ID: ${buildInfo.cacheBust}`);
        
        // Add deployment info to window for debugging
        window.deploymentInfo = buildInfo;
        
        // Add meta tag for cache busting
        const metaTag = document.createElement('meta');
        metaTag.name = 'deployment-cache-bust';
        metaTag.content = buildInfo.cacheBust;
        document.head.appendChild(metaTag);
        
    }, []);
    
    return null; // This component doesn't render anything
};

// Universal cache-busting hook
export const useUniversalCache = () => {
    const buildInfo = {
        buildTime: process.env.REACT_APP_BUILD_TIME,
        commitHash: process.env.REACT_APP_COMMIT_HASH,
        buildNumber: process.env.REACT_APP_BUILD_NUMBER,
        pipelineId: process.env.REACT_APP_PIPELINE_ID,
        cacheBust: process.env.REACT_APP_CACHE_BUST
    };
    
    return buildInfo;
};

export default UniversalCacheBuster;